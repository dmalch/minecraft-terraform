#!/bin/bash
set -e

# Update OS and install start script
# Thanks to https://github.com/darrelldavis for the script
ubuntu_linux_setup() {
  export SSH_USER="ubuntu"
  export DEBIAN_FRONTEND=noninteractive
  # install adopt open jdk 16   
  wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
  /usr/bin/add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
  /usr/bin/apt-get update
  /usr/bin/apt-get -yq install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" adoptopenjdk-16-hotspot-jre wget awscli jq
  /bin/cat <<"__UPG__" > /etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
__UPG__

  # Init script for starting, stopping
  cat <<INIT > /etc/init.d/minecraft
#!/bin/bash
# Short-Description: Minecraft server
start() {
  echo "Starting minecraft server from /home/minecraft..."
  start-stop-daemon --start --quiet --pidfile /home/minecraft/minecraft.pid -m -b -c $SSH_USER -d /home/minecraft --exec /usr/bin/java -- -Xmx2G -Xms2G -jar /home/minecraft/minecraft_server.jar nogui
}
stop() {
  echo "Stopping minecraft server..."
  start-stop-daemon --stop --pidfile /home/minecraft/minecraft.pid
}
case \$1 in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    sleep 5
    start
    ;;
esac
exit 0
INIT

  # Start up on reboot
  /bin/chmod +x /etc/init.d/minecraft
  /usr/sbin/update-rc.d minecraft defaults
}

### Thanks to https://github.com/kenoir for pointing out that as of v15 (?) we have to
### use the Mojang version_manifest.json to find java download location
### See https://minecraft.gamepedia.com/Version_manifest.json
download_minecraft_server() {

  WGET=$(which wget)

  # version_manifest.json lists available MC versions
  $WGET -O /home/minecraft/version_manifest.json https://launchermeta.mojang.com/mc/game/version_manifest.json

  # Find latest version number if user wants that version (the default)
  if [[ "${minecraft_version}" == "latest" ]]; then
    MC_VERS=$(jq -r '.["latest"]["'"release"'"]' /home/minecraft/version_manifest.json)
  fi

  # Index version_manifest.json by the version number and extract URL for the specific version manifest
  VERSIONS_URL=$(jq -r '.["versions"][] | select(.id == "'"$MC_VERS"'") | .url' /home/minecraft/version_manifest.json)
  # From specific version manifest extract the server JAR URL
  SERVER_URL=$(curl -s $VERSIONS_URL | jq -r '.downloads | .server | .url')
  # And finally download it to our local MC dir
  $WGET -O /home/minecraft/minecraft_server.jar $SERVER_URL
}

# Create mc dir, sync S3 to it and download mc if not already there (from S3)
ubuntu_linux_setup
/bin/mkdir -p /home/minecraft
/usr/bin/aws s3 sync s3://${minecraft_bucket} /home/minecraft

# Download server if it doesn't exist on S3 already (existing from previous install)
# To force a new server version, remove the server JAR from S3 bucket
if [[ ! -e "/home/minecraft/minecraft_server.jar" ]]; then
  download_minecraft_server
fi

# Cron job to sync data to S3 every five mins
/bin/cat <<CRON > /etc/cron.d/minecraft
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/minecraft
*/5 * * * *  $SSH_USER  /usr/bin/aws s3 sync /home/minecraft s3://${minecraft_bucket}
CRON

# Update minecraft EULA
/bin/cat >/home/minecraft/eula.txt<<EULA
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Tue Jan 27 21:40:00 UTC 2015
eula=true
EULA

# Not root
/bin/chown -R $SSH_USER /home/minecraft

# Start the server
/etc/init.d/minecraft start

exit 0
