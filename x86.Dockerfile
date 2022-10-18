FROM ubuntu:22.10
LABEL maintainer="Kirill Milash <kirilledition@protonmail.com>"

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
ENV OPENBLAS="/home/openblas_pkg"

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    clang \
    cmake \
    tree \
    git \
    wget

RUN git config --global http.sslverify false

ARG MAKE_JOBS=4

RUN git clone https://gitlab.com/libeigen/eigen.git && \
    cd eigen && \
    git checkout tags/3.3.7 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/home/eigen_pkg .. && \
    make -j ${MAKE_JOBS} && \
    make install -j ${MAKE_JOBS}

RUN wget --no-check-certificate --quiet \
        https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz && \
    tar xzf ./boost_1_80_0.tar.gz && \
    cd ./boost_1_80_0 && \
    ./bootstrap.sh --prefix=/home/boost_pkg && \
    ./b2 install -j ${MAKE_JOBS}

RUN git clone https://github.com/madler/zlib.git && \
    cd zlib && \
    git checkout tags/v1.2.12 && \
    ./configure --prefix=/home/zlib_pkg && \
    make install -j ${MAKE_JOBS}

RUN git clone https://github.com/tcltk/tcl.git  && \
    cd tcl/unix && \
    git checkout tags/core-8-6-12 && \
    ./configure --prefix=/home/tcl_pkg && \
    make -j ${MAKE_JOBS} && \
    make install -j ${MAKE_JOBS} && \
    ln -s /home/tcl_pkg/bin/tclsh9.0 /home/tcl_pkg/bin/tclsh

RUN git clone https://github.com/sqlite/sqlite.git && \
    cd sqlite && \
    git checkout tags/version-3.39.3 && \
    ./configure --prefix /home/sqlite_pkg && \
    make -j ${MAKE_JOBS} && \
    make install -j ${MAKE_JOBS}

RUN git clone https://github.com/facebook/zstd.git && \
    cd zstd/build/cmake && \
    git checkout tags/v1.4.10 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="/home/zstd_pkg" .. && \
    make -j ${MAKE_JOBS} && \
    make install -j ${MAKE_JOBS}

RUN git clone https://github.com/yixuan/spectra/ && \
    cd spectra && \
    git checkout tags/v1.0.1 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="home/spectra_pkg" ..

RUN wget --no-check-certificate --quiet \
        https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz && \
    tar xzf gsl-latest.tar.gz && \
    cd gsl-2.7.1 && \
    ./configure --prefix=/home/gsl_pkg && \
    make -j ${MAKE_JOBS} && \
    make install -j ${MAKE_JOBS}

RUN  wget --no-check-certificate --quiet \
        https://registrationcenter-download.intel.com/akdlm/irc_nas/18483/l_onemkl_p_2022.0.2.136_offline.sh && \
    chmod +x l_onemkl_p_2022.0.2.136_offline.sh && \
    ./l_onemkl_p_2022.0.2.136_offline.sh -a -s --eula accept  --install-dir /home/mkl_pkg

COPY static_build_cmake.patch /home/

RUN git clone https://github.com/jianyangqt/gcta.git && \
    cd gcta && \
    git checkout ed0536a && \
    git submodule update --init && \
    patch CMakeLists.txt /home/static_build_cmake.patch && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j ${MAKE_JOBS}
