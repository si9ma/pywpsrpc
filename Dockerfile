FROM ubuntu:latest
LABEL maintainer "si9ma <si9ma@si9ma.com>"

WORKDIR /wps

RUN set -eux && \
	apt-get update && \
    # install dependencies
	apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools xserver-xorg-video-dummy python3 && \
	# install wps
	wget -O wps-office.deb https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11664/wps-office_11.1.0.11664.XA_amd64.deb && \
	dpkg -i wps-office.deb && \
	rm -rf *.deb && \
    # install fonts
    git clone https://github.com/iamdh4/ttf-wps-fonts.git && \
    cd ttf-wps-fonts && \
    bash install.sh && \
    rm -rf ttf-wps-fonts && \
    # install pywpsrpc
    pip install sip