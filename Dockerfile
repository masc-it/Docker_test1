FROM ubuntu:18.04

MAINTAINER onipot

ARG USER=android

RUN apt-get update && apt-get install -y \
        build-essential git neovim wget unzip sudo \
        libc6 libncurses5 libstdc++6 lib32z1 libbz2-1.0 \
        libxrender1 libxtst6 libxi6 libfreetype6 libxft2 \
	nano \
        qemu qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-8-jdk xvfb \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd -g 1000 -r $USER
RUN useradd -u 1000 -g 1000 --create-home -r $USER
RUN adduser $USER libvirt
RUN adduser $USER kvm

RUN echo "$USER:$USER" | chpasswd

RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER
RUN usermod -aG sudo $USER
RUN usermod -aG plugdev $USER

VOLUME /androidstudio-data
RUN chown $USER:$USER /androidstudio-data

COPY provisioning/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
COPY provisioning/ndkTests.sh /usr/local/bin/ndkTests.sh
RUN chmod +x /usr/local/bin/*
COPY provisioning/51-android.rules /etc/udev/rules.d/51-android.rules

USER $USER

WORKDIR /home/$USER

ARG ANDROID_STUDIO_URL=https://redirector.gvt1.com/edgedl/android/studio/ide-zips/3.6.3.0/android-studio-ide-192.6392135-linux.tar.gz
ARG ANDROID_STUDIO_VERSION=3.6

RUN wget "$ANDROID_STUDIO_URL" -O android-studio.tar.gz
RUN tar xzvf android-studio.tar.gz
RUN rm android-studio.tar.gz

RUN ln -s /studio-data/profile/AndroidStudio$ANDROID_STUDIO_VERSION .AndroidStudio$ANDROID_STUDIO_VERSION
RUN ln -s /studio-data/Android Android
RUN ln -s /studio-data/profile/android .android
RUN ln -s /studio-data/profile/java .java
RUN ln -s /studio-data/profile/gradle .gradle
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

RUN wget -O eclipse_java.tar.gz http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-linux-gtk-x86_64.tar.gz
RUN mkdir eclipse_java && tar -xzvf eclipse_java.tar.gz -C eclipse_java --strip-components 1

RUN chmod +x /home/$USER/eclipse_java/*

RUN wget -O eclipse_cpp.tar.gz https://mirrors.dotsrc.org/eclipse//technology/epp/downloads/release/2020-03/R/eclipse-cpp-2020-03-R-incubation-linux-gtk-x86_64.tar.gz
RUN mkdir eclipse_cpp && tar -xzvf eclipse_cpp.tar.gz -C eclipse_cpp --strip-components 1

RUN chmod +x /home/$USER/eclipse_cpp/*

WORKDIR /home/$USER

COPY provisioning/run_eclipse_java.sh run_eclipse_java.sh
COPY provisioning/run_eclipse_cpp.sh run_eclipse_cpp.sh

ENTRYPOINT [ "/usr/local/bin/docker_entrypoint.sh" ]
