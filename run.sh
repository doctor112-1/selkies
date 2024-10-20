#!/bin/sh
export DISPLAY=:0
Xvfb "$DISPLAY" -screen 0 $1x$2x24 & openbox & ./selkies-gstreamer/selkies-gstreamer-run --addr=0.0.0.0 --port=$3 --enable_https=false --https_cert=/etc/ssl/certs/ssl-cert-snakeoil.pem --https_key=/etc/ssl/private/ssl-cert-snakeoil.key --basic_auth_user=$4 --basic_auth_password=$5 --encoder=x264enc --enable_resize=true & ./Timer.x86_64
