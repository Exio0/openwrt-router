#!/bin/sh

echo "=================================="
echo " CONFIGURACION FIREWALL "
echo "=================================="

uci commit firewall

service firewall restart

echo "✔ Firewall reiniciado"