#!/bin/bash

set_timezone()
{
    if [ -f /usr/share/zoneinfo/$TZ ]; then 
        rm -f /etc/localtime && ln -s /usr/share/zoneinfo/$TZ /etc/localtime
    fi
}

dir=(
    /var/lib/pydio
    /var/lib/mysql
    /etc/pki/tls
    /var/cache/pydio
)

change_uids()
{
if [ ! -z "$UID" ]; then
    usermod -u $UID apache
    chown -R apache /var/lib/pydio
fi
if [ ! -z "$GID" ]; then
    groupmod -g $GID apache
    chgrp -R apache /var/lib/pydio
fi
}

move_dirs()
{
    for i in "${dir[@]}"; do mkdir -p /data$(dirname $i) ; done
    for i in "${dir[@]}"; do mv $i /data$i; done
}

link_dirs()
{
    for i in "${dir[@]}"; do rm -rf $i && ln -s /data$i $i ; done
}
run()
{
    #Start command
    supervisord -n
}

set_timezone

if [ ! -d /data/var ] ; then
    change_uids
    move_dirs
    link_dirs
    /bin/sh /etc/gencert.sh
    run
else
    link_dirs
    run
fi
