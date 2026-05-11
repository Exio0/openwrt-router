#!/bin/sh

echo "=================================="
echo " CONFIGURACION WIREGUARD "
echo "=================================="

read -p "Nombre interfaz WG (ej wg0): " WG_IF

# Comprobar si existe
EXISTS=$(uci show network | grep "network.$WG_IF=")

if [ -z "$EXISTS" ]; then

    echo "Creando interfaz WireGuard..."

    uci set network.$WG_IF="interface"
    uci set network.$WG_IF.proto="wireguard"

    read -p "Private key servidor: " WG_PRIVKEY
    read -p "IP WG servidor (ej 10.10.10.1/24): " WG_IP
    read -p "Puerto escucha (ej 51820): " WG_PORT

    uci set network.$WG_IF.private_key="$WG_PRIVKEY"
    uci set network.$WG_IF.listen_port="$WG_PORT"
    uci add_list network.$WG_IF.addresses="$WG_IP"

    echo "✔ Interfaz creada"

else

    echo "✔ Interfaz ya existe"

fi

echo ""
echo "=== CONFIGURACION FIREWALL WG ==="

ZONE_EXISTS=$(uci show firewall | grep "name='wg'")

if [ -z "$ZONE_EXISTS" ]; then

    uci add firewall zone
    uci set firewall.@zone[-1].name='wg'
    uci set firewall.@zone[-1].network="$WG_IF"
    uci set firewall.@zone[-1].input='ACCEPT'
    uci set firewall.@zone[-1].output='ACCEPT'
    uci set firewall.@zone[-1].forward='ACCEPT'

    uci add firewall forwarding
    uci set firewall.@forwarding[-1].src='wg'
    uci set firewall.@forwarding[-1].dest='lan'

    uci add firewall rule
    uci set firewall.@rule[-1].name='Allow-WireGuard'
    uci set firewall.@rule[-1].src='wan'
    uci set firewall.@rule[-1].proto='udp'
    uci set firewall.@rule[-1].dest_port='51820'
    uci set firewall.@rule[-1].target='ACCEPT'

fi

echo ""
echo "=== AÑADIR PEERS ==="

while true; do

    read -p "¿Añadir peer? (y/n): " ANSWER

    [ "$ANSWER" != "y" ] && break

    read -p "Nombre peer: " PEER_NAME
    read -p "Public key peer: " PEER_PUBKEY
    read -p "IP peer (ej 10.10.10.2/32): " PEER_IP
    read -p "Persistent Keepalive (ej 25): " KEEPALIVE

    PEER_SECTION=$(uci add network wireguard_$WG_IF)

    uci set network.$PEER_SECTION.description="$PEER_NAME"
    uci set network.$PEER_SECTION.public_key="$PEER_PUBKEY"
    uci add_list network.$PEER_SECTION.allowed_ips="$PEER_IP"
    uci set network.$PEER_SECTION.persistent_keepalive="$KEEPALIVE"

    echo ""
    echo "✔ Peer añadido"

done

uci commit network
uci commit firewall

service network restart
service firewall restart

echo ""
echo "✔ WireGuard configurado"