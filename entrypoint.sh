#!/bin/sh

sleep 2
cd /home/container

MODIFIED_STARTUP=$(eval echo "$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')")

/usr/local/bin/proot \
  --rootfs="${HOME}" \
  -0 -w "${HOME}" \
  -b /dev -b /sys -b /proc \
  --kill-on-exit \
  /bin/sh -c '
if [ ! -e "/.installed" ]; then
    if [ -f "/rootfs.tar.xz" ]; then rm -f "/rootfs.tar.xz"; fi
    if [ -f "/rootfs.tar.gz" ]; then rm -f "/rootfs.tar.gz"; fi
    rm -rf /tmp/sbin
    printf "nameserver 193.41.60.1\nnameserver 193.41.60.2\n" > /etc/resolv.conf
    touch "/.installed"
else
    if [ -r "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc" > /dev/null
    fi
    printf "Welcome back\n# \n"
    eval "sh"
fi
'
