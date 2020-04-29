ARGS=""

ARGS="${ARGS} -h pc"

ARGS="${ARGS} -v /dev/bus/usb:/dev/bus/usb"

ARGS="${ARGS} --net=host"

ARGS="${ARGS} --env=DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"

mkdir -p studio-data/profile/AndroidStudio3.6
mkdir -p studio-data/profile/android
mkdir -p studio-data/profile/gradle
mkdir -p studio-data/profile/java
docker run -it --rm $ARGS -v `pwd`/studio-data:/studio-data -v `pwd`/studio-data/eclipse/java/configuration:/home/android/eclipse_java/configuration -v `pwd`/studio-data/eclipse/cpiu/configuration:/home/android/eclipse_cpp/configuration --privileged --group-add plugdev onipot/env_test:latest $@
