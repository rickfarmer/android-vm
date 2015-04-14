#!/usr/bin/env bash
echo " "
echo "***** Installing System Tools... *****"
echo " "
sudo apt-get -y --force-yes update >/dev/null 2>&1
sudo apt-get -y --force-yes install curl >/dev/null 2>&1
sudo apt-get -y --force-yes install unzip >/dev/null 2>&1
sudo apt-get -y --force-yes install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 >/dev/null 2>&1
sudo apt-get -y --force-yes update >/dev/null 2>&1
sudo apt-get -y --force-yes install apt-file && apt-file update
sudo apt-get -y --force-yes install python-software-properties >/dev/null 2>&1

#  http://askubuntu.com/questions/147400/problems-with-eclipse-and-android-sdk
sudo apt-get -y --force-yes install ia32-libs >/dev/null 2>&1

echo " "
echo "***** Installing Vbox guest utils (for high res support) *****"
echo " "
sudo apt-get -y --force-yes install virtualbox-guest-utils virtualbox-guest-x11 virtualbox-guest-dkms

echo " "
echo "***** Installing git... *****"
sudo apt-get -y --force-yes install git

# Install a desktop for the Android graphical tooling, e.g. Eclipse

#echo "What is your preferred Ubuntu desktop?"
#echo "1) Unity desktop (Ubuntu default)"
#echo "2) Gnome desktop"
#echo "3) Gnome Classic desktop"
#echo "4) xfce (lightweight desktop)"
#echo "5) KDE desktop"
#echo "6) Do not install a desktop (use the command line interface only)"
#read case;

#case $case in
#    1) echo "Installing Unity desktop..." | sudo aptitude install -y --without-recommends ubuntu-desktop >/dev/null 2>&1;;
#    2) echo "Installing Gnome desktop..." | sudo apt-get install -y ubuntu-desktop >/dev/null 2>&1;;
#	3) echo "Installing Gnome Classic desktop..." | sudo apt-get install -y gnome-panel >/dev/null 2>&1;;
#    4) echo "Installing xfce lightweight desktop..." | sudo apt-get install -y xubuntu-desktop >/dev/null 2>&1;;
#    5) echo "Installing KDE desktop..." | sudo apt-get install -y kubuntu-desktop >/dev/null 2>&1;;
#    6) exit
#esac 
echo " "
echo "***** Installing Ubuntu Unity Desktop... *****"
echo " "
sudo aptitude install -y --without-recommends ubuntu-desktop >/dev/null 2>&1

# Or, the following desktop...

#echo "Installing Ubuntu Gnome Desktop..."
#sudo apt-get install -y ubuntu-desktop >/dev/null 2>&1

# Or, the following desktop...

#echo "Installing Ubuntu xfce lightweight desktop..."
#sudo apt-get install -y xubuntu-desktop >/dev/null 2>&1

# Or, the following desktop...

#echo "Installing Ubuntu KDE Desktop..."
#sudo apt-get install -y kubuntu-desktop >/dev/null 2>&1
echo " "
echo "***** Installing Android Studio *****"
echo " "
cd /tmp
sudo curl -O https://dl.google.com/dl/android/studio/ide-zips/1.1.0/android-studio-ide-135.1740770-linux.zip
sudo unzip /tmp/android-studio-ide-135.1740770-linux.zip >/dev/null 2>&1
sudo mv /tmp/android-studio /usr/local/android/android_studio/
sudo rm -rf /tmp/android-studio-ide-135.1740770-linux.zip

echo " "
echo "***** Installing the Android SDK and Build Tools *****"
echo " "
sudo curl -O http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz
sudo tar zxvf android-sdk_r24.1.2-linux.tgz
cd /tmp/android-sdk-linux/tools
echo "y" | sudo ./android update sdk --no-ui --filter 1,2,3,4,24,35,36,41,42,43,21,tool,platform-tool,doc
cd /tmp/
sudo mv /tmp/android-sdk-linux /usr/local/android/sdk/
sudo rm -rf /tmp/android-sdk_r24.1.2-linux.tgz

echo " "
echo "***** Installing Android NDK... *****"
echo " "
cd /tmp
sudo curl -O http://dl.google.com/android/ndk/android-ndk-r9-linux-x86_64.tar.bz2
sudo tar -jxf /tmp/android-ndk-r9-linux-x86_64.tar.bz2 >/dev/null 2>&1
sudo mv /tmp/android-ndk-r9 /usr/local/android/ndk
sudo rm -rf /tmp/android-ndk-r9-linux-x86_64.tar.bz2

sudo mkdir /usr/local/android/sdk/add-ons

sudo chmod -R 755 /usr/local/android

sudo ln -s /usr/local/android/sdk/tools/android /usr/bin/android
sudo ln -s /usr/local/android/sdk/platform-tools/adb /usr/bin/adb
echo " "
echo "***** Updating ANDROID_HOME... *****"
echo " "
cd ~/
cat << End >> .profile
export ANDROID_HOME="/usr/local/android/sdk"
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
End

echo " "
echo "***** Adding USB device driver information... *****"
echo "For more detail see http://developer.android.com/tools/device.html"
echo " "

sudo cp /vagrant/51-android.rules /etc/udev/rules.d
sudo chmod a+r /etc/udev/rules.d/51-android.rules

sudo service udev restart

sudo android update adb
sudo adb kill-server
sudo adb start-server

echo " "
echo " "
echo " "
echo "[ Next Steps ]================================================================"
echo " "
echo "1. Manually setup a USB connection for your Android device to the new VM"
echo " "
echo "	If using VMware Fusion (for example, will be similar for VirtualBox):"
echo "  	1. Plug your android device hardware into the computers USB port"
echo "  	2. Open the 'Virtual Machine Library'"
echo "  	3. Select the VM, e.g. 'android-vm: default', right-click and choose"
echo " 		   'Settings...'"
echo "  	4. Select 'USB & Bluetooth', check the box next to your device and set"
echo " 		   the 'Plug In Action' to 'Connect to Linux'"
echo "  	5. Plug the device into the USB port and verify that it appears when "
echo "         you run 'lsusb' from the command line"
echo " "
echo "2. Your device should appear when running 'lsusb' enabling you to use adb, e.g."
echo " "
echo "		$ adb devices"
echo "			ex. output,"
echo " 		       List of devices attached"
echo " 		       007jbmi6          device"
echo " "
echo "		$ adb shell"
echo " 		    i.e. to log into the device (be sure to enable USB debugging on the device)"
echo " "
echo "See the included README.md for more detail on how to run and work with this VM."
echo " "
echo "[ Start your Ubuntu VM ]======================================================"
echo " "
echo "To start the VM, "
echo " 	To use with VirtualBox (free),"
echo " "
echo "			$ vagrant up"
echo " "
echo " 	To use with VMware Fusion (OS X) (requires paid plug-in),"
echo " "
echo "			$ vagrant up --provider=vmware_fusion"
echo " "
echo " 	To use VMware Workstation (Windows, Linux) (requires paid plug-in),"
echo " "
echo "			$ vagrant up --provider=vmware_workstation"
echo " "
echo " "
echo "See the included README.md for more detail on how to run and work with this VM."

