clear
if [ ! "`whoami`" = "root" ]
then
    echo "Please run script as root."
    exit 1
else echo "( ͡° ͜ʖ ͡°) Script Made By Shuncey Balba ( ͡° ͜ʖ ͡°)"
fi
touch install.log
chmod 777 install.log
echo Downloading Files
p_url="https://raw.githubusercontent.com/dsd/linux/es8316"
files="
sound/soc/codecs/es8316.c
sound/soc/codecs/es8316.h
sound/soc/codecs/Makefile
sound/soc/codecs/Kconfig
sound/soc/intel/Kconfig
sound/soc/intel/boards/Makefile
sound/soc/intel/boards/cht_bsw_es8316.c
sound/soc/intel/boards/bytcht_es8316.c
sound/soc/intel/sst/atom/sst_acpi.c
sound/soc/intel/atom/sst/sst_acpi.c
sound/soc/intel/atom/sst-atom-controls.h
sound/soc/intel/common/sst-acpi.h
sound/soc/intel/common/sst-dsp.h
sound/soc/intel/atom/sst-mfld-platform.h
sound/soc/intel/atom/sst/sst.h
sound/soc/intel/atom/sst-mfld-dsp.h
"
for f in $files
do
    echo $f > install.log 2>&1
    mkdir -p `dirname $f` > install.log 2>&1
    wget $p_url/$f > install.log 2>&1 
    mv `basename $f` $f > install.log 2>&1
done
rm sound/soc/codecs/Makefile
    rm sound/soc/intel/boards/Makefile
    echo "snd-soc-es8316-objs := es8316.o
obj-m    += snd-soc-es8316.o" >> sound/soc/codecs/Makefile
chmod +x sound/soc/codecs/Makefile

echo "snd-soc-sst-byt-cht-es8316-objs := bytcht_es8316.o
obj-m += snd-soc-sst-byt-cht-es8316.o" >> sound/soc/intel/boards/Makefile
chmod +x sound/soc/intel/boards/Makefile

echo "snd-intel-sst-acpi-objs += sst_acpi.o
obj-m += snd-intel-sst-acpi.o" >> sound/soc/intel/atom/sst/Makefile
chmod +x sound/soc/intel/atom/sst/Makefile

echo Compiling

# ubuntu
C_FLAGS="-C /usr/src/linux-headers-`uname -r`"
# opensuse
# C_FLAGS="-C /usr/src/linux-`uname -r`"
c_dir=`pwd`
for mf in `find $c_dir -type f -name "Makefile"`
do
    echo $mf > install.log 2>&1
    cd `dirname $mf` > install.log 2>&1
    make $C_FLAGS M=`pwd` modules > install.log 2>&1
    mv *.ko $c_dir > install.log 2>&1
    cd $c_dir > install.log 2>&1
done

echo Inserting snd-intel-sst-acpi.ko to Kernel
if insmod snd-intel-sst-acpi.ko > install.log 2>&1 ; then
    printf 'Modules inserted To Kernel Succesfully
'
else
    printf 'snd-intel-sst-acpi.ko Already Exists
'
fi
echo Inserting snd-soc-sst-byt-cht-es8316.ko to Kernel
if insmod snd-soc-sst-byt-cht-es8316.ko > install.log 2>&1 ; then
    printf 'snd-soc-sst-byt-cht-es8316.ko inserted To Kernel Succesfully
'
else
    printf 'snd-soc-sst-byt-cht-es8316.ko Already Exists
'
fi
echo Inserting snd-soc-es8316.ko to Kernel
if insmod snd-soc-es8316.ko > install.log 2>&1 ; then
    printf 'snd-soc-es8316.ko inserted To Kernel Succesfully
'
else
    printf 'snd-soc-es8316.ko Already Exists
'
fi

echo "Downloading And Extracting UCM files..."
PURGE_UNZIP=false && [ ! $(sudo bash -c "command -v unzip") ] && sudo apt -y install unzip > /dev/null 2>&1 && PURGE_UNZIP=true
sudo rm -rf UCM
sudo mkdir UCM
cd UCM
sudo wget --timeout=10 "https://github.com/plbossart/UCM/archive/master.zip" > /dev/null 2>&1
sudo unzip master.zip > /dev/null 2>&1
sudo rm -f master.zip
echo "Installing UCM Files..."
sudo mkdir -p /usr/share/alsa/ucm
sudo cp -rf UCM-master/* /usr/share/alsa/ucm
sudo cp -rf /usr/share/alsa/ucm/bytcr-rt5651/asound.state /var/lib/alsa
sudo rm -rf UCM-master
sudo mkdir /usr/share/alsa/ucm/bytcht-es8316 > install.log 2>&1
sudo wget --timeout=10 "https://github.com/kernins/linux-chwhi12/raw/master/configs/audio/ucm/bytcht-es8316/HiFi" -O /usr/share/alsa/ucm/bytcht-es8316/HiFi > /dev/null 2>&1
sudo wget --timeout=10 "https://github.com/kernins/linux-chwhi12/raw/master/configs/audio/ucm/bytcht-es8316/bytcht-es8316.conf" -O /usr/share/alsa/ucm/bytcht-es8316/bytcht-es8316.conf > /dev/null 2>&1
# add HdmiLpeAudio.conf
sed '1,/^exit$/d' < ../$0 | base64 -d > install.log 2>&1 | sudo tee $0.zip > /dev/null 2>&1
sudo unzip $0.zip > /dev/null 2>&1
sudo rm -f $0.zip
sudo mkdir -p /usr/share/alsa/cards > install.log 2>&1
sudo cp HdmiLpeAudio.conf /usr/share/alsa/cards > install.log 2>&1
cd ..
sudo rm -rf UCM
[ ${PURGE_UNZIP} ] && sudo apt -y purge unzip > /dev/null 2>&1
echo "Finished Installing UCM Files"


echo "blacklist snd_hdmi_lpe_audio" > /etc/modprobe.d/blacklist_hdmi.conf
echo Cleaming Up
sudo rm -rf sound
sudo rm -rf install.log
sudo rm -rf snd-intel-sst-acpi.ko 
sudo rm -rf snd-soc-es8316.ko
sudo rm -rf snd-soc-sst-byt-cht-es8316.ko 
echo "Donate -> https://www.paypal.me/shunceybalbacid"
echo "Does Sound Work? If not plug in your Headphones Wait for 10 Seconds To Continue"
timeout 10s speaker-test -t wav -c 6 > install.log 2>&1
while true; do
   
    read -p "Do you want to reboot now? Y/N: " yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) exit;;
        * ) echo ;;
    esac
done
