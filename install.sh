#!/bin/sh

echo "=================================="
echo " INSTALACION DE PAQUETES OPENWRT "
echo "=================================="

opkg update

while read pkg; do

    if opkg list-installed | grep -q "^$pkg "; then
        echo "[YA INSTALADO] $pkg"
    else
        echo "[INSTALANDO] $pkg"
        opkg install "$pkg"
    fi

done < packages.txt

echo ""
echo "✔ Instalacion completada"