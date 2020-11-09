#!/bin/bash

echo -e "\e[0mIniciando configuración de la plataforma GoPiGo.\e[0m"


###################################################################################################
# Comprobamos que haya conexion a internet.
###################################################################################################

echo -e "\e[1;33mComprobando conexión a internet...\e[0m"

ping -c5 google.com > /dev/null

if [ $? -ne 0 ]
then
        echo -e "\e[1;31mNecesitas conexion a internet para ejecutar este script...\e[0m"
        exit 1
fi

echo -e "\e[1;32mConexión a internet disponible.\e[0m"


###################################################################################################
# Instalamos aplicaciones.
###################################################################################################

echo -e "\e[1;33mInstalando aplicaciones...\e[0m"


# Actualizamos repositorios.
apt-get update

# Actualizamos cualquier paquete que pueda estar obsoleto.
apt-get upgrade -y

# Instalamos Vim para poder editar texto por terminal.
apt install vim -y

# Instalamos git por si acaso...
apt install git -y

# Instalamos tree (no se utilizara, pero lo pone en la documentacion...).
apt install tree -y

# Instalamos curl para poder hacer otras instalaciones.
apt install curl -y

# La documentacion recomienda reinstalar openssh.
apt remove openssh-server -y
apt install openssh-server -y

# Reiniciamos el servicio para asegurar que se apliquen los cambios.
systemctl enable ssh
servicer ssh restart

# NO se instala VNC server. No queremos que explote la Raspberry, gracias.
# NO configuramos el HDMI puesto que no se va a utilizar.
# NO se instala Geany IDE puesto que se utilizara Visual Studio Code en remoto.

echo -e "\e[1;32mAplicaciones instaladas con éxito.\e[0m"


###################################################################################################
# Instalamos drivers del robot.
###################################################################################################

echo -e "\e[1;33mInstalando los drivers de GoPiGo...\e[0m"

# Instalamos la libreria GoPiGo.
su -c "curl -kL dexterindustries.com/update_gopigo3 | bash" pi

# Instalamos los sensores.
su -c "curl -kL dexterindustries.com/update_sensors | bash" pi

echo -e "\e[1;32mDrivers de GoPiGo instalados con éxito.\e[0m"

###################################################################################################
# Configuracion de la camara.
###################################################################################################

echo -e "\e[1;33mInstalando la cámara...\e[0m"

# Habilitamos el acceso a la camara.
echo 'start_x=1' >> /boot/config.txt
echo 'gpu_mem=128' >> /boot/config.txt

# Instalamos el modulo python de la camara.
export READTHEDOCS=True
pip install wheel
pip install picamera

echo -e "\e[1;32mCámara instalada con éxito.\e[0m"

###################################################################################################
# Instalamos ROS Melodic
###################################################################################################

echo -e "\e[1;33mInstalando ROS Melodic...\e[0m"

echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

apt update

apt install ros-melodic-desktop -y

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y

apt install python-rosdep -y

rosdep init
rosdep update

echo -e "\e[1;32mROS Melodic instalado con éxito.\e[0m"

read -p 'El sistema debe de reiniciarse para asegurar que los cambios sean aplicados. Pulse cualquier tecla para continuar...'

reboot
