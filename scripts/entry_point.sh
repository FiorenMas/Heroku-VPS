#!/usr/bin/env bash

#==============================================
# OpenShift or non-sudo environments support
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
#==============================================

mkdir -p /Desktop
cat << EOF >  /Desktop/Chromium.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Chrome
Comment=Access the Internet
Exec=/usr/bin/google-chrome --no-sandbox --disable-dev-shm-usage
Icon=google-chrome
Path=
Terminal=false
StartupNotify=true
EOF
cat << EOF >  /Desktop/Anydesk.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Anydesk
Comment=Anydesk
Exec=/usr/bin/anydesk
Icon=anydesk
Path=
Terminal=false
StartupNotify=true
EOF
cat << EOF >  /Desktop/Parsec.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Parsec
Comment=Parsec
Exec=/usr/bin/parsecd %u
Icon=/usr/share/icons/hicolor/256x256/apps/parsecd.png
Path=
Terminal=false
StartupNotify=true
EOF
cat << EOF >  /Desktop/qbittorrent.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=qbittorrent
Comment=qbittorrent
Exec=qbittorrent
Icon=qbittorrent
Path=
Terminal=false
StartupNotify=true
EOF

chmod +x /Desktop/Chromium.desktop
chmod +x /Desktop/Anydesk.desktop
chmod +x /Desktop/Parsec.desktop
chmod +x /Desktop/qbittorrent.desktop

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-ubuntu}:x:$(id -u):0:${USER_NAME:-ubuntu} user:/home/${USER_NAME:-ubuntu}:/sbin/nologin" >> /etc/passwd
  fi
fi

/usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf &

SUPERVISOR_PID=$!

function shutdown {
    echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord..."
    kill -s SIGTERM ${SUPERVISOR_PID}
    wait ${SUPERVISOR_PID}
    echo "Shutdown complete"
}

trap shutdown SIGTERM SIGINT
wait ${SUPERVISOR_PID}
