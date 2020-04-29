AOSP_ARGS=""

AOSP_ARGS="${AOSP_ARGS} -h kali"

AOSP_ARGS="${AOSP_ARGS} -v /dev/bus/usb:/dev/bus/usb"

AOSP_ARGS="${AOSP_ARGS} --net=host"

AOSP_ARGS="${AOSP_ARGS} --env=DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"


mkdir -p studio-data/profile/AndroidStudio3.6
mkdir -p studio-data/profile/android
mkdir -p studio-data/profile/gradle
mkdir -p studio-data/profile/java
docker run -it --rm $AOSP_ARGS -v `pwd`/studio-data:/studio-data -v `pwd`/studio-data/eclipse/configuration:/home/android/eclipse/configuration --privileged --group-add plugdev onipot/env_test:latest $@
