FROM ubuntu:20.04
LABEL maintainer "si9ma <si9ma@si9ma.com>"

WORKDIR /wps

ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN set -eux && \
    apt-get update && \
    apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools xserver-xorg-video-dummy python3 wget bsdmainutils xdg-utils git pip libxslt-dev

# install wps
RUN wget -O wps-office.deb https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11664/wps-office_11.1.0.11664.XA_amd64.deb && \
    dpkg -i wps-office.deb && \
    rm -rf *.deb 

# install fonts
RUN git clone https://github.com/iamdh4/ttf-wps-fonts.git && \
    cd ttf-wps-fonts && \
    bash install.sh && \
    cd ../ && \
    rm -rf ttf-wps-fonts

# copy pywpsrpc code
COPY README.md README_en.md pyproject.toml project.py /wps/pywpsrpc/
COPY py /wps/pywpsrpc/py
COPY include /wps/pywpsrpc/include
COPY sip /wps/pywpsrpc/sip
COPY wpsrpc-sdk /wps/pywpsrpc/wpsrpc-sdk

WORKDIR /wps/pywpsrpc

# build && install pywpsrpc
# use sip 6.4.0 to build pywpsrpc
RUN pip install sip==6.4.0 && \
    sip-wheel && \
    pip install pywpsrpc-*.whl

# install cjk fonts
RUN apt-get install -y fonts-wqy-zenhei ttf-wqy-microhei xfonts-wqy ttf-wqy-zenhei fonts-noto-cjk

# wps config
COPY ./config/Office.conf /root/.config/Kingsoft/Office.conf

# video-dummy config
COPY ./config/dummy.conf /wps/dummy.conf

# entrypoint
COPY ./entrypoint.sh /wps/entrypoint.sh

# converter
COPY ./converter/converter.py /wps/converter.py

# clean
RUN rm -rf /wps/pywpsrpc
WORKDIR /wps

ENTRYPOINT ["/bin/bash", "/wps/entrypoint.sh"]