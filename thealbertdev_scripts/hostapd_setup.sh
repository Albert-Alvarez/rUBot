#!/bin/bash

MAC=$(cat /sys/class/net/wlan0/address | sed -e 's/://g')
MAC=${MAC:(-4)}
MAC=${MAC^^}

cat > /etc/hostapd/hostapd.conf << EOL
country_code=ES
interface=wlan0
ssid=RoboticsUB_${MAC}
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=CorrePiCorre
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL
