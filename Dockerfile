FROM ubuntu:22.04
LABEL maintainer="Kirill Milash <kirilledition@protonmail.com>"

WORKDIR "/home"

ENV DEBIAN_FRONTEND=noninteractive
ENV SPECTRA_LIB="/home/spectra/include"
ENV MKLROOT="/home/mkl_pkg/mkl/latest"
ENV BOOST_LIB="/usr/include/boost"
ENV EIGEN3_INCLUDE_DIR="/home/eigen_pkg/include/eigen3"

RUN apt update && apt install -y \
        build-essential=12.9ubuntu3 \
        wget=1.21.2-2ubuntu1 \
        git=1:2.34.1-1ubuntu1.8 \
        unzip=6.0-26ubuntu3.1 \
        libboost-all-dev=1.74.0.3ubuntu7 \
        zlib1g-dev=1:1.2.11.dfsg-2ubuntu9.2 \
        libgomp1=12.1.0-2ubuntu1~22.04 \
        libsqlite3-dev=3.37.2-2ubuntu0.1 \
        libzstd-dev=1.4.8+dfsg-3build1 \
        libgsl-dev=2.7.1+dfsg-3 \
        ca-certificates=20211016ubuntu0.22.04.1 \
        gnupg=2.2.27-3ubuntu2.1 \
        software-properties-common=0.99.22.6 \
        cmake=3.22.1-1ubuntu1.22.04.1 \
        tcl=8.6.11+1build2

RUN  wget --no-check-certificate --quiet \
        https://registrationcenter-download.intel.com/akdlm/irc_nas/18483/l_onemkl_p_2022.0.2.136_offline.sh && \
    chmod +x l_onemkl_p_2022.0.2.136_offline.sh && \
    ./l_onemkl_p_2022.0.2.136_offline.sh -a -s --eula accept  --install-dir /home/mkl_pkg

RUN git clone https://gitlab.com/libeigen/eigen.git && \
    cd eigen && \
    git checkout tags/3.3.7 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/home/eigen_pkg .. && \
    make -j 12 && \
    make install -j 12

RUN git clone https://github.com/yixuan/spectra/ && \
    cd spectra && \
    git checkout tags/v1.0.1 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="/home/spectra_pkg" ..

RUN git clone https://github.com/jianyangqt/gcta.git && \
    cd gcta && \
    git checkout f22c624 && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 12

ENV PATH="/home/gcta/build:${PATH}"

CMD ["gcta64"]
