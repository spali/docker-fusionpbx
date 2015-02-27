#!/bin/bash

/usr/bin/freeswitch -u freeswitch -g freeswitch -conf $FREESWITCH_CONF -db $FREESWITCH_DATA/db -log /var/log/freeswitch -scripts /var/lib/fusionpbx/scripts -run /var/run/freeswitch -storage /var/lib/fusionpbx/storage -recordings /var/lib/fusionpbx/recordings -nf -rp -reincarnate
