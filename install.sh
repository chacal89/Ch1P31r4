#!/bin/bash
echo limpando possiveis instalações
rm -rf /usr/src/ast*
rm -rf /usr/src/dongle*
rm -rf /usr/src/chan*
read year 

clear
echo Abaixo comente a linha referente ao CD
read year 
nano /etc/apt/sources.list
echo Atualizando repositorios
read year
apt-get update
apt-get upgrade
echo Instalando dependencias
read year
apt-get install openssh-server php-pear apache2-mpm-prefork php-http php5-gd php5-cli php5-mysql mysql-server sudo libapache2-mod-php5 -y
apt-get install unixodbc-dev libmyodbc sudo ntp build-essential libncurses5-dev libssl-dev libxml2-dev libsqlite3-dev uuid-dev vim-nox linux-headers-`uname -r` subversion unzip automake lshw hdparm -y
apt-get install -y mysql-server build-essential linux-headers-`uname -r` subversion checkinstall bison flex apache2 php5 php5-curl php5-cli php5-mysql php-pear php-db php5-gd curl sox libncurses5-dev libssl-dev libmysqlclient15-dev mpg123 libxml2-dev -y
apt-get install automake autoconf subversion p7zip p7zip-full -y
apt-get install usb-modeswitch* -y
apt-get install minicom -y
dpkg-reconfigure tzdata
apt-get install ntpdate -y
ntpdate us.pool.ntp.org
hwclock --systohc
apt-get install ntp -y

echo Baixando Asterisk
read year
cd /usr/src
wget http://smartadmin.pbsys.com.br/ast.tar.gz
tar xzvf ast.tar.gz
cd /usr/src/asterisk-1.8.32.3/

echo Compilando asterisk
read year
./configure --disable-asteriskssl
contrib/scripts/get_mp3_source.sh
echo Em extras sounds adicione mais sons e em addons adicionar o suporte a cdr_mysql
read year
make menuselect
echo Compilando Asterisk
read year
make && make install && make config
########### ATÉ AQUI OK
echo Criando Usuario asterisk
read year
adduser --system --group --home /var/lib/asterisk --no-create-home --gecos "Asterisk PBX" asterisk

echo Ajustando Permissões
read year
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/lib/asterisk
chown -R asterisk. /var/log/asterisk
chown -R asterisk. /var/spool/asterisk
chown -R asterisk. /usr/lib/asterisk
echo reiniciando asterisk
read year
service asterisk restart
echo Substitua a seguinte linha
echo "error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR"
read year
nano /etc/php5/apache2/php.ini
echo Reiniciando apache
read year
service apache2 restart

echo Baixando chan dongle
read year
cd /usr/src
svn checkout https://github.com/bg111/asterisk-chan-dongle.git dongle-read-only
cd /usr/src/dongle-read-only/trunk
wget http://smartadmin.pbsys.com.br/config.guess --no-check-certificate
wget http://smartadmin.pbsys.com.br/config.sub --no-check-certificate

echo ADICIONAR TRECHO DE CODIGO AO PDISCOVERY
echo "{ 0x12d1, 0x1506, { 3, 2, /* 0 */ } },		/* E303 Brasil by Giovanni Bosa */"
echo E COMENTAR LINHA ACIMA
read year
nano pdiscovery.c

echo Compilando chan dongle
read year
cd /usr/src/dongle-read-only/trunk
aclocal && autoconf && automake -a
./configure
echo Instalando chan dongle
read year
make && make install

echo incluir abaixo do root
echo "www-data ALL=(ALL) NOPASSWD: ALL"
echo "asterisk ALL=(ALL) NOPASSWD: ALL"
read year
visudo

echo adicione as seguintes linhas ao crontab
echo "0 */1 * * * sudo sh /etc/asterisk/reiniciarasterisk.sh >> /dev/null"
echo "  */5 * * * * sudo /etc/asterisk/verificamodem.php"
echo "###  0 4 * * * sudo sh /etc/asterisk/reiniciageral.sh"
echo " 0 */1 * * *  sudo /etc/asterisk/limpamodem.php >> /dev/null"
echo 
echo 
echo "*/1 * * * *  sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 5 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 10 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 15 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 20 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 25 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 30 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 35 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 40 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 45 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 50 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * *  sleep 55 && sudo /etc/asterisk/monitorasterisk.php"
read year
crontab -e


echo Adicionar:
echo 
echo 'KERNEL=="ttyUSB*", SYMLINK+="hw-modem-0", MODE="0666", OWNER="asterisk", GROUP="uucp"'
echo 'KERNEL=="ttyUSB*", SYMLINK+="hw-audio-0", MODE="0666", OWNER="asterisk", GROUP="uucp"'
echo 'KERNEL=="ttyUSB*", SYMLINK+="hw-data-0", MODE="0666", OWNER="asterisk", GROUP="uucp"'
read year
nano /etc/udev/rules.d/50-udev.rules

cd /usr/src
mkdir repo
cd repo
echo Baixando Scripts AGI
read year
wget http://smartadmin.pbsys.com.br/agi-bin.tar.gz
echo Baixando Arquivos de Configuração
read year
wget http://smartadmin.pbsys.com.br/asterisk.tar.gz
echo Baixando Modulo de envio SMS pela URL
read year
wget http://smartadmin.pbsys.com.br/enviador.tar.gz

rm -rf /etc/asterisk
tar -xzvf asterisk.tar.gz
mv asterisk /etc

rm -rf /var/lib/asterisk/agi-bin
tar -xzvf agi-bin.tar.gz
mv agi-bin /var/lib/asterisk

rm -rf /var/www/enviador
tar -xzvf enviador.tar.gz
mv enviador /var/www/

touch /var/log/asterisk/sms.txt

echo Ajustando Permissões
read year
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/lib/asterisk
chown -R asterisk. /var/log/asterisk
chown -R asterisk. /var/spool/asterisk
chown -R asterisk. /usr/lib/asterisk
echo reiniciando asterisk
read year
service asterisk restart


echo Ajustando Permissões dos arquivos .conf do asterisk para web
read year
chmod 777 -R /etc/asterisk

echo Ajustando Permissão Interfaces
read year
chmod 777 /etc/network/interfaces

echo Ajustando Permissões dos arquivos SMS e USSD
read year
chmod 777 -R /var/log/asterisk


echo CTRL+C para cancelar reboot
read year
reboot

