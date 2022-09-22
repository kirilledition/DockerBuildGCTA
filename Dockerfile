FROM ubuntu:22.10
MAINTAINER Kirill Milash <kirilledition@protonmail.com>

WORKDIR "/home"

SHELL ["/bin/bash", "-c"]

ENV PATH="${PATH}:/home/tcl_pkg/bin"
ENV CPATH="${CPATH}:/home/tcl_pkg/include"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/home/tcl_pkg/lib"

ENV CPATH="${CPATH}:/home/zstd_pkg/include"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/zstd_pkg/lib"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/home/zstd_pkg/lib"

ENV CPATH="${CPATH}:/home/gsl_pkg/include"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/gsl_pkg/lib"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/home/gsl_pkg/lib"

ENV CPATH="${CPATH}:/home/zlib_pkg/include"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/zlib_pkg/lib"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/home/zlib_pkg/lib"

ENV CPATH="${CPATH}:/home/sqlite_pkg/include"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/sqlite_pkg/lib"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/home/sqlite_pkg/lib"

ENV EIGEN3_INCLUDE_DIR="/home/eigen_pkg/include/eigen3"
ENV SPECTRA_LIB="/home/spectra/include"
ENV BOOST_LIB="/home/boost_pkg/include"
ENV MKLROOT="/home/mkl_pkg/mkl/latest"

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    clang \
    cmake \
    tree \
    git \
    wget

RUN git config --global http.sslverify false

RUN git clone https://gitlab.com/libeigen/eigen.git && \
    cd eigen && \
    git checkout tags/3.3.7 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/home/eigen_pkg .. && \
    make -j 24 && \
    make install -j 24

RUN wget --no-check-certificate --quiet \
        https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz && \
    tar xzf ./boost_1_80_0.tar.gz && \
    cd ./boost_1_80_0 && \
    ./bootstrap.sh --prefix=/home/boost_pkg && \
    ./b2 install -j 24

RUN git clone https://github.com/madler/zlib.git && \
    cd zlib && \
    ./configure --prefix=/home/zlib_pkg && \
    make install -j 24

RUN git clone https://github.com/tcltk/tcl.git  && \
    cd tcl/unix && \
    git checkout tags/core-8-6-12 && \
    ./configure --prefix=/home/tcl_pkg && \
    make -j 24 && \
    make install -j 24 && \
    ln -s /home/tcl_pkg/bin/tclsh9.0 /home/tcl_pkg/bin/tclsh

RUN git clone https://github.com/sqlite/sqlite.git && \
    cd sqlite && \
    ./configure --prefix /home/sqlite_pkg && \
    make -j 24 && \
    make install -j 24

RUN git clone https://github.com/facebook/zstd.git && \
    cd zstd/build/cmake && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="/home/zstd_pkg" .. && \
    make -j 24 && \
    make install -j 24

RUN git clone https://github.com/yixuan/spectra/ && \
    cd spectra && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="home/spectra_pkg" ..

RUN wget --no-check-certificate --quiet \
        https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz && \
    tar xzf gsl-latest.tar.gz && \
    cd gsl-2.7.1 && \
    ./configure --prefix=/home/gsl_pkg && \
    make -j 24 && \
    make install -j 24

# RUN git clone https://github.com/xianyi/OpenBLAS.git && \
#     cd OpenBLAS && \
#     make -j 24 && \
#     make install PREFIX=/home/openblas_pkg -j 24

RUN  wget --no-check-certificate --quiet \
        https://registrationcenter-download.intel.com/akdlm/irc_nas/18483/l_onemkl_p_2022.0.2.136_offline.sh && \
    chmod +x l_onemkl_p_2022.0.2.136_offline.sh && \
    ./l_onemkl_p_2022.0.2.136_offline.sh -a -s --eula accept  --install-dir /home/mkl_pkg

COPY static_build_cmake.patch /home/

RUN git clone https://github.com/jianyangqt/gcta.git && \
    cd gcta && \
    git submodule update --init && \
    patch CMakeLists.txt /home/static_build_cmake.patch && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 24
