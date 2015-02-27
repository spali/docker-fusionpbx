# docker-fusionpbx

[FusionPBX](http://www.fusionpbx.com) server with [FreeSwitch](https://freeswitch.org/) included.

## How To

When the container is running and you have published the web-interface directly or via a reverse proxy, you could access the web-interface by `http://yourHostName` or `https://yourHostName` with default login `admin` and password `fusionpbx`.

### Examples

Starts a container and expose the FusionPBX web-interface on port 80.
```
docker run -d --name fusionpbx -p 80:80 -p 5060:5060/tcp -p 5060:5060/udp \
  -p 16384:16384/udp -p 16385:16385/udp -p 16386:16386/udp -p 16387:16387/udp -p 16388:16388/udp \
  -p 16389:16389/udp -p 16390:16390/udp -p 16391:16391/udp -p 16392:16392/udp -p 16393:16393/udp \
  -v <PATH_TO_PERSISTENT_CONFIG>:/etc/freeswitch \
  spali/fusionpbx
```
####Using SSL
Starts a container and expose the FusionPBX web-interface on port 443 with ssl.<br>
```
docker run -d --name fusionpbx -p 443:443 -p 5060:5060/tcp -p 5060:5060/udp \
  -p 16384:16384/udp -p 16385:16385/udp -p 16386:16386/udp -p 16387:16387/udp -p 16388:16388/udp \
  -p 16389:16389/udp -p 16390:16390/udp -p 16391:16391/udp -p 16392:16392/udp -p 16393:16393/udp \
  -v <PATH_TO_PERSISTENT_CONFIG>:/etc/freeswitch \
  spali/fusionpbx
```
<dl>
  <dt>!! Warning !!</dt>
  <dd>
By default and if you don't provide your own certificate, a generated self signed certificate is used. You can provide your own certificate by mounting the container volume `/etc/nginx/certs`. The expected filenames are `fusionpbx.pem` and `fusionpbx.key`.
</dd>
####Provide configuration repository
Clone FreeSwitch configuration on initialisation from a git repository.
```
docker run -d --name fusionpbx -p 443:443 -p 5060:5060/tcp -p 5060:5060/udp \
  -p 16384:16384/udp -p 16385:16385/udp -p 16386:16386/udp -p 16387:16387/udp -p 16388:16388/udp \
  -p 16389:16389/udp -p 16390:16390/udp -p 16391:16391/udp -p 16392:16392/udp -p 16393:16393/udp \
  -e FREESWITCH_INIT_REPO https://github.com/spali/freeswitch_conf_minimal.git \
  spali/fusionpbx
```
####Using a reverse proxy
Starts a container with the environment variable used by [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) implementation for nginx reverse proxy for docker containers.
```
docker run -d --name fusionpbx -p 5060:5060/tcp -p 5060:5060/udp \
  -p 16384:16384/udp -p 16385:16385/udp -p 16386:16386/udp -p 16387:16387/udp -p 16388:16388/udp \
  -p 16389:16389/udp -p 16390:16390/udp -p 16391:16391/udp -p 16392:16392/udp -p 16393:16393/udp \
  -v <PATH_TO_PERSISTENT_CONFIG>:/etc/freeswitch \
  -e VIRTUAL_HOST=<HOST_NAME> -e VIRTUAL_PORT=80 \
  spali/fusionpbx
```

## Limitations
* Due the lack in docker to dynamically expose ports or bigger ranges of ports, this [Dockerfile](Dockerfile) is limited to 10 concurrent calls.

## To Do
* include some basic apps (editors etc.)
* an automated way to configure the external ip and rdp port range (maybe by environment variables)
* setup fail2ban/logrotation for freeswitch and webinterface (everything after fusionpbx in the install script)
* add nginx basic auth option for additional security
* implement autorestart of vanished services (nginx,php5-fpm,freeswitch)
* implement a dialplan to dynamically enable and disable access to web interface 

