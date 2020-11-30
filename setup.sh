#!/bin/bash

echo -e "\e[0mIniciando configuración de la plataforma GoPiGo.\e[0m"


###################################################################################################
# Instalamos drivers del robot.
###################################################################################################

echo -e "\e[1;33mInstalando los drivers de GoPiGo...\e[0m"

# Instalamos la libreria GoPiGo.

su - $SUDO_USER -c "curl -kL dexterindustries.com/update_gopigo3 | bash -s -- --user-local --bypass-gui-installation"
su - $SUDO_USER -c "curl -kL dexterindustries.com/update_sensors | bash -s -- --user-local --bypass-gui-installation"

echo -e "\e[1;32mDrivers de GoPiGo instalados con éxito.\e[0m"


###################################################################################################
# Configuracion de la camara.
###################################################################################################

echo -e "\e[1;33mInstalando la cámara...\e[0m"

# Habilitamos el acceso a la camara.
echo 'start_x=1' >> /boot/config.txt

# Instalamos el modulo python de la camara.
su - $SUDO_USER -c "pip install picamera"

echo -e "\e[1;32mCámara instalada con éxito. Reiniciando Raspberry Pi.\e[0m"


###################################################################################################
# Instalamos ROS Melodic
###################################################################################################

echo -e "\e[1;33mInstalando ROS...\e[0m"

sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

apt-get update
apt-get upgrade

apt install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake

rosdep init

su - $SUDO_USER -c "bash" << EOF

rosdep update

mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws

rosinstall_generator robot --rosdistro melodic --deps --wet-only --tar > melodic-robot-wet.rosinstall

wstool init -j2 src melodic-robot-wet.rosinstall

rosdep install -y --from-paths src --ignore-src --rosdistro melodic -r --os=debian:buster

EOF

cd ~/ros_catkin_ws
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/melodic -j2

su - $SUDO_USER -c "echo \"source /opt/ros/melodic/setup.bash\" >> ~/.bashrc"

echo -e "\e[1;32mROS instalado con éxito. Reiniciando Raspberry Pi.\e[0m"


###################################################################################################
# Salimos y reiniciamos
###################################################################################################

reboot
