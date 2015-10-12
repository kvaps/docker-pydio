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

move_dirs()
{
    mkdir -p /data/etc
    mkdir -p /data/var/lib
    mkdir -p /data/var/log
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
    move_dirs
    link_dirs
    run
else
    link_dirs
    run
fi
