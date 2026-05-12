#!/bin/sh

echo "=================================="
echo " INSTALACION DE PAQUETES OPENWRT "
echo "=================================="

apk update

while read pkg; do

    if apk list | grep -q "^$pkg "; then
        echo "[YA INSTALADO] $pkg"
    else
        echo "[INSTALANDO] $pkg"
        apk add "$pkg"
    fi

done < packages.txt

echo ""
echo "✔ Instalacion completada"
