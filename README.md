Pydio in a Docker
=================

This is a fork of official [pydio-core](https://hub.docker.com/r/pydio/pydio-core/) image for docker.
I'm a little modified startup scripts, It is making it possible save the pydio configuration.

Default credentials
-------------------
  - admin
  - P@ssw0rd

Run
---

```bash
docker run \
    --name pydio \
    -h pydio \
    -v /opt/pydio:/data:rw \
    --env TZ=Europe/Moscow \
    -p 80:80 \
    -p 443:443 \
    -d \
    kvaps/pydio
```

Systemd unit
------------

Example of systemd unit: `/etc/systemd/system/pydio.service`

```bash
[Unit]
Description=Pydio
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --name pydio -h pydio -v /opt/pydio:/data --env TZ=Europe/Moscow -p 80:80 -p 443:443 kvaps/pydio
ExecStop=/usr/bin/docker stop -t 5 pydio ; /usr/bin/docker rm -f pydio

[Install]
WantedBy=multi-user.target
```
