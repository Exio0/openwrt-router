#!/bin/sh

echo "=================================="
echo " CONFIGURACION DE RED "
echo "=================================="

read -p "IP LAN (ej 192.168.1.1): " LAN_IP
read -p "Mascara (ej 255.255.255.0): " LAN_MASK

uci set network.lan.ipaddr="$LAN_IP"
uci set network.lan.netmask="$LAN_MASK"

uci commit network

service network restart

echo ""
echo "✔ Red configurada"