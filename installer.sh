#!/usr/bin/env bash


# color codes
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;34m'
light_cyan='\033[1;96m'
reset='\033[0m'



# GLOBAL varaibles
BASE_DIR="$HOME/SDRAngel"
BUILD_DIR="$BASE_DIR/build"
INSTALL_DIR="$BASE_DIR/install"

if [[  -d $BASE_DIR  ]] ;then 
    printf "Detected old work dir removing..\n"
    rm -rf $BASE_DIR
    printf "Success..\n"
fi

mkdir $BASE_DIR
mkdir $INSTALL_DIR
mkdir $BUILD_DIR



function INFO_PRINTER(){
    text=$1
    printf "$blue[ INFO ]:$reset $text .\n"
}


function ERR_PRINTER(){
    text=$1
    printf "$red[ ERROR ]:$reset $text .\n"
}


function WARN_PRINTER(){
    text=$1
    printf "$red[ WARN ]:$reset $text .\n"
}


function TITLE_PRINTER(){
    text=$1
    printf "$green<[ $text ]>$reset\n"
}

function CHECK_LAST_COMMAND(){
    if [ "$?" != "0" ] ;then 
        ERR_PRINTER "The previous command failed so the operation is aborted"
        sleep 0.1
        exit 1
    
    else 
        INFO_PRINTER "OK"
    
    fi
}

function CLEAR_AND_CONTINUE(){
    INFO_PRINTER "Clearing screen.."
    sleep 1
    clear
}



TITLE_PRINTER "SDRAngel installer @ Prime Security"
INFO_PRINTER "Printing varaibles..."

echo 
printf "[ BASE DIR ]: $BASE_DIR\n"
printf "[ BUILD DIR ]: $BUILD_DIR\n"
printf "[ INSTALL DIR ]: $INSTALL_DIR\n"
printf "[ nproc ]: $nproc"
echo

sleep 1



INFO_PRINTER "Required packages are installed with apt"
sleep 0.1
echo
echo


sudo apt-get -y install \
git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev \
qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev \
qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev \
qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts \
libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev \
qtwebengine5-dev qtbase5-private-dev libqt5gamepad5-dev \
libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex \
ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz


CHECK_LAST_COMMAND


echo
TITLE_PRINTER "Non-hardware dependencies installation starting"
echo
sleep 0.1


CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: APT"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/srcejon/aptdec.git
CHECK_LAST_COMMAND

cd aptdec
CHECK_LAST_COMMAND

git checkout libaptdec
CHECK_LAST_COMMAND

git submodule update --init --recursive
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/aptdec ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND




echo 
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: MBElib" 

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/szechyjs/mbelib.git
CHECK_LAST_COMMAND

cd mbelib
CHECK_LAST_COMMAND

git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/mbelib ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND





echo 
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: SerialDV"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/f4exb/serialDV.git
CHECK_LAST_COMMAND

cd serialDV
CHECK_LAST_COMMAND

git reset --hard "v1.1.4"
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/serialdv ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



echo 
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: DSDcc"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/f4exb/dsdcc.git
CHECK_LAST_COMMAND

cd dsdcc
CHECK_LAST_COMMAND

git reset --hard "v1.9.3"
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=$INSTALL_DIR/mbelib/include -DLIBMBE_LIBRARY=$INSTALL_DIR/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=$INSTALL_DIR/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=$INSTALL_DIR/serialdv/lib/libserialdv.so ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND






echo
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: Codec2/FreeDV"

sudo apt-get -y install libspeexdsp-dev libsamplerate0-dev
CHECK_LAST_COMMAND

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/drowe67/codec2-dev.git codec2
CHECK_LAST_COMMAND

cd codec2
CHECK_LAST_COMMAND

git reset --hard "v1.0.3"
CHECK_LAST_COMMAND

mkdir build_linux; cd build_linux
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/codec2 ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



echo 
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: SGP4"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/dnwrnr/sgp4.git
CHECK_LAST_COMMAND

cd sgp4
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/sgp4 ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND




echo
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: LibSigMF"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/f4exb/libsigmf.git
CHECK_LAST_COMMAND

cd libsigmf
CHECK_LAST_COMMAND

git checkout "new-namespaces"
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libsigmf .. 
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



echo 
CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install: CM265cc" 

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/f4exb/cm256cc.git
CHECK_LAST_COMMAND

cd cm256cc
CHECK_LAST_COMMAND

#git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559
#CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/cm256cc ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND




echo 
CLEAR_AND_CONTINUE
TITLE_PRINTER "Starting Hardware dependencies installs"
echo
sleep 1




CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install Airspy"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/airspy/airspyone_host.git libairspy
CHECK_LAST_COMMAND

cd libairspy
CHECK_LAST_COMMAND

git reset --hard 37c768ce9997b32e7328eb48972a7fda0a1f8554
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libairspy ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND


CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install SDRplay RSP1"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/f4exb/libmirisdr-4.git
CHECK_LAST_COMMAND

cd libmirisdr-4
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libmirisdr ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND


CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install SDRplay (Using SDRplay's V3 API)"

git clone https://github.com/srcejon/sdrplayapi.git
CHECK_LAST_COMMAND

cd sdrplayapi
CHECK_LAST_COMMAND

sudo ./install_lib.sh
CHECK_LAST_COMMAND


CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install RTL-SDR"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/osmocom/rtl-sdr.git librtlsdr
CHECK_LAST_COMMAND

cd librtlsdr
CHECK_LAST_COMMAND

git reset --hard be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/librtlsdr ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install Pluto SDR"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/analogdevicesinc/libiio.git
CHECK_LAST_COMMAND

cd libiio
CHECK_LAST_COMMAND

git reset --hard v0.21
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libiio -DINSTALL_UDEV_RULE=OFF ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND




CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install BladeRF all versions"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/Nuand/bladeRF.git
CHECK_LAST_COMMAND

cd bladeRF/host
CHECK_LAST_COMMAND

git reset --hard "2023.02"
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libbladeRF -DINSTALL_UDEV_RULES=OFF ..
CHECK_LAST_COMMAND

make -j $(nproc) install 
CHECK_LAST_COMMAND



CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install HackRF"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/greatscottgadgets/hackrf.git
CHECK_LAST_COMMAND

cd hackrf/host
CHECK_LAST_COMMAND

git reset --hard "v2022.09.1"
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libhackrf -DINSTALL_UDEV_RULES=OFF ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install LimeSDR"

cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/myriadrf/LimeSuite.git
CHECK_LAST_COMMAND

cd LimeSuite
CHECK_LAST_COMMAND

git reset --hard "v20.01.0"
CHECK_LAST_COMMAND

mkdir builddir; cd builddir
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/LimeSuite ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



CLEAR_AND_CONTINUE
INFO_PRINTER "Starting install AirspyHF"


cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/airspy/airspyhf
CHECK_LAST_COMMAND

cd airspyhf
CHECK_LAST_COMMAND

git reset --hard 1af81c0ca18944b8c9897c3c98dc0a991815b686
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/libairspyhf ..
CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND



echo 
CLEAR_AND_CONTINUE
INFO_PRINTER "Proccess complated."
INFO_PRINTER "Starting main build"
sleep 0.5


cd $BUILD_DIR
CHECK_LAST_COMMAND

git clone https://github.com/f4exb/sdrangel.git
CHECK_LAST_COMMAND

cd sdrangel
CHECK_LAST_COMMAND

mkdir build; cd build
CHECK_LAST_COMMAND

INFO_PRINTER "Starting cmake build.."

cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DMIRISDR_DIR=$INSTALL_DIR/libmirisdr \
-DAIRSPY_DIR=$INSTALL_DIR/libairspy \
-DAIRSPYHF_DIR=$INSTALL_DIR/libairspyhf \
-DBLADERF_DIR=$INSTALL_DIR/libbladeRF \
-DHACKRF_DIR=$INSTALL_DIR/libhackrf \
-DRTLSDR_DIR=$INSTALL_DIR/librtlsdr \
-DLIMESUITE_DIR=$INSTALL_DIR/LimeSuite \
-DIIO_DIR=$INSTALL_DIR/libiio \
-DPERSEUS_DIR=$INSTALL_DIR/libperseus \
-DXTRX_DIR=$INSTALL_DIR/xtrx-images \
-DSOAPYSDR_DIR=$INSTALL_DIR/SoapySDR \
-DUHD_DIR=$INSTALL_DIR/uhd \
-DAPT_DIR=$INSTALL_DIR/aptdec \
-DCM256CC_DIR=$INSTALL_DIR/cm256cc \
-DDSDCC_DIR=$INSTALL_DIR/dsdcc \
-DSERIALDV_DIR=$INSTALL_DIR/serialdv \
-DMBE_DIR=$INSTALL_DIR/mbelib \
-DCODEC2_DIR=$INSTALL_DIR/codec2 \
-DSGP4_DIR=$INSTALL_DIR/sgp4 \
-DLIBSIGMF_DIR=$INSTALL_DIR/libsigmf \
-DDAB_DIR=$INSTALL_DIR/libdab \
-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/sdrangel ..

CHECK_LAST_COMMAND

make -j $(nproc) install
CHECK_LAST_COMMAND

