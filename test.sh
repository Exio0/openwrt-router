#!/bin/sh

echo "=================================="
echo " TEST OPENWRT "
echo "=================================="

echo ""
echo "=== INTERNET ==="

ping -c 3 8.8.8.8

echo ""
echo "=== WIREGUARD ==="

wg show

echo ""
echo "=== RUTAS ==="

ip route

echo ""
echo "=== FIREWALL ==="

uci show firewall