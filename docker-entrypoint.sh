#!/bin/bash
set -e

if [ "$1" = "/usr/bin/supervisord" ]; then

	# reset nginx hosts based on environment variable
	[ -n "$(ls -A "/etc/nginx/sites-enabled/")" ] && rm /etc/nginx/sites-enabled/*
	if [ -n "$FUSIONPBX_FORCE_SSL" ]; then
		ln -s /etc/nginx/sites-available/fusionpbx_ssl /etc/nginx/sites-enabled/fusionpbx_ssl
	else
		ln -s /etc/nginx/sites-available/fusionpbx /etc/nginx/sites-enabled/fusionpbx
	fi

	[ ! -d /etc/freeswitch ] && mkdir -p /etc/freeswitch
	# restore default fusionpbx freeswitch config files
	[ -z "$(ls -A "$FUSIONPBX_CONF")" ] && cp -R /usr/share/examples/fusionpbx/default/* $FUSIONPBX_CONF/
	[ ! -d $FUSIONPBX_CONF/switch/conf ] && mkdir -p $FUSIONPBX_CONF/switch/conf
	[ ! -h $FUSIONPBX_CONF/switch/conf ] && \
        	rmdir $FUSIONPBX_CONF/switch/conf && \
        	ln -s $FREESWITCH_CONF $FUSIONPBX_CONF/switch/conf
	chown -R www-data:www-data $FREESWITCH_CONF
	chown -R freeswitch:freeswitch $FREESWITCH_DATA


	[ ! -d $FUSIONPBX_DB ] && mkdir -p $FUSIONPBX_DB
	# restore default fusionpbx sound files
	[ ! -d $FUSIONPBX_DATA/sounds ] && mkdir -p $FUSIONPBX_DATA/sounds
	[ ! -d $FUSIONPBX_DATA/sounds/music ] && cp -R /usr/share/examples/fusionpbx/default_sounds/* $FUSIONPBX_DATA/sounds/
	[ ! -d $FUSIONPBX_DATA/scripts ] && cp -R /usr/share/examples/fusionpbx/resources/install/scripts $FUSIONPBX_DATA/
	[ ! -d /usr/share/freeswitch/sounds/music ] && mkdir -p /usr/share/freeswitch/sounds/music
	[ ! -d $FUSIONPBX_DATA/sounds/custom ] && mkdir -p $FUSIONPBX_DATA/sounds/custom
	[ ! -h /usr/share/freeswitch/sounds/music/fusionpbx ] && ln -s $FUSIONPBX_DATA/sounds/music /usr/share/freeswitch/sounds/music/fusionpbx
	[ ! -h /usr/share/freeswitch/sounds/custom ] && ln -s $FUSIONPBX_DATA/sounds/custom /usr/share/freeswitch/sounds/custom

        find "$FUSIONPBX_DATA" -type d -exec chmod 775 {} +
        find "$FUSIONPBX_DATA" -type f -exec chmod 664 {} +
        find "$FUSIONPBX_DB" -type d -exec chmod 777 {} +
        find "$FUSIONPBX_DB" -type f -exec chmod 666 {} +
        chown -R www-data:www-data $FUSIONPBX_CONF
        chown -R www-data:www-data $FUSIONPBX_DATA/sounds
        chown -R www-data:www-data $FUSIONPBX_DATA/sounds

	# first time: call fusionpbx install script
        if [ -z "$(ls -A "$FUSIONPBX_DB")" ]; then
                /usr/sbin/php5-fpm &
                /usr/sbin/nginx &
                sleep 5
                curl -k -s -d "db_path=$FUSIONPBX_DB&db_name=fusionpbx.db&install_default_country=$FUSIONPBX_DEFAULT_COUNTRY&install_template_name=enhanced&admin_username=admin&admin_password=fusionpbx&db_type=sqlite&install_step=3" https://localhost/resources/install.php >/dev/null
                /usr/sbin/nginx -s stop
                killall php5-fpm
        fi

fi      

exec $@

