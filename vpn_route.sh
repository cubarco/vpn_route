#!/system/bin/sh

# VPN_SERVER_IP is the real ip of vpn server
VPN_SERVER_IP="ip.of.your.vpn"

# Name of virtual interface, default: ppp0
# Unneccessary to change
VPN_IF_NAME="ppp0"

DEFAULT_ROUTE=$( ip route show table all | grep -e '^default' | grep -v $VPN_IF_NAME | grep -v 'fe80')
DEFAULT_TABLE_ID=$( echo $DEFAULT_ROUTE | sed -n 's/.*table\s*\([0-9]*\)/\1/p' )
DEFAULT_DEV=$( echo $DEFAULT_ROUTE | sed -n 's/.*dev\s*\([0-9a-zA-Z]*\).*/\1/p' )
DEFAULT_GW=$( echo $DEFAULT_ROUTE | sed -n 's/.*\s\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*/\1/p' )
DNS1=$( getprop | grep net.dns1 | sed -n 's/.*\[\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*/\1/p' )
DNS2=$( getprop | grep net.dns2 | sed -n 's/.*\[\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*/\1/p' )

echo "Default route is \"$DEFAULT_ROUTE\""
echo "Default table_id is \"$DEFAULT_TABLE_ID\""
echo "Default dev is \"$DEFAULT_DEV\""
echo "Default gw is \"$DEFAULT_GW\""
echo
ip route del default table $DEFAULT_TABLE_ID
ip route add $VPN_SERVER_IP via $DEFAULT_GW dev $DEFAULT_DEV
ip route add $DNS1 via $DEFAULT_GW dev $DEFAULT_DEV
ip route add $DNS2 via $DEFAULT_GW dev $DEFAULT_DEV
ip route add default dev $VPN_IF_NAME
