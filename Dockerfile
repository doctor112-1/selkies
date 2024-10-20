FROM ubuntu:latest

RUN apt-get update -y
RUN dpkg --add-architecture i386
RUN apt-get install -y software-properties-common
RUN add-apt-repository multiverse
RUN apt-get update -y
RUN apt-get install -y steam
RUN apt-get install -y xvfb
RUN apt-get install -y openbox
RUN apt-get update && apt-get install --no-install-recommends -y jq tar gzip ca-certificates curl libpulse0 libegl1 libgl1 libopengl0 libgles1 libgles2 libglvnd0 libglx0 wayland-protocols libwayland-dev libwayland-egl1 x11-utils x11-xkb-utils x11-xserver-utils xserver-xorg-core libx11-xcb1 libxcb-dri3-0 libxkbcommon0 libxdamage1 libxfixes3 libxv1 libxtst6 libxext6 xvfb
RUN export SELKIES_VERSION="$(curl -fsSL "https://api.github.com/repos/selkies-project/selkies-gstreamer/releases/latest" | jq -r '.tag_name' | sed 's/[^0-9\.\-]*//g')"
#RUN cd ~ && curl -fsSL "https://github.com/selkies-project/selkies-gstreamer/releases/download/v1.6.1/selkies-gstreamer-portable-v1.6.1_amd64.tar.gz" | tar -xzf -
RUN curl -fsSL "https://github.com/selkies-project/selkies-gstreamer/releases/download/v1.6.2/selkies-gstreamer-portable-v1.6.2_amd64.tar.gz" | tar -xzf -
RUN export DISPLAY=:0
RUN export DISPLAY="${DISPLAY:-:0}"
RUN export PIPEWIRE_LATENCY="32/48000"
RUN export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
RUN export PIPEWIRE_RUNTIME_DIR="${PIPEWIRE_RUNTIME_DIR:-${XDG_RUNTIME_DIR:-/tmp}}"
RUN export PULSE_RUNTIME_PATH="${PULSE_RUNTIME_PATH:-${XDG_RUNTIME_DIR:-/tmp}/pulse}"
RUN export PULSE_SERVER="${PULSE_SERVER:-unix:${PULSE_RUNTIME_PATH:-${XDG_RUNTIME_DIR:-/tmp}/pulse}/native}"
COPY run.sh run.sh
RUN chmod +x run.sh
EXPOSE 8080
RUN apt-get install -y sudo
RUN rm -rf /etc/xdg/openbox/menu.xml
COPY menu.xml /etc/xdg/openbox/menu.xml
COPY stop.sh stop.sh
RUN chmod +x stop.sh
COPY Timer.x86_64 Timer.x86_64
RUN apt-get install -y dbus
RUN apt-get install -y dbus-x11
#RUN echo "app    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
#RUN useradd -ms /bin/bash -p "$(openssl passwd -1 reyv)" reyv
#RUN usermod -aG sudo reyv
RUN adduser --disabled-password --gecos '' reyv
RUN adduser reyv sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER reyv
#RUN Xvfb "$DISPLAY" -screen 0 1024x768x24 & openbox & ./selkies-gstreamer/selkies-gstreamer-run --addr=0.0.0.0 --port=8080 --enable_https=false --https_cert=/etc/ssl/certs/ssl-cert-snakeoil.pem --https_key=/etc/ssl/private/ssl-cert-snakeoil.key --basic_auth_user=user --basic_auth_password=mypasswd --encoder=x264enc --enable_resize=false
ENTRYPOINT ["./run.sh"]
