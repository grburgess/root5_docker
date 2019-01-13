FROM python:2.7-slim


# FROM alpine:3.8
# RUN apk update &&\
#     apk add python \
#             python-dev \
# 	    ca-certificates \
#             py-pip \
#             openntpd \
#             build-base \
#             python-dev \
#             musl-dev \
#             gfortran \
#             libgfortran \
# 	    bash \
# #	    zlib-dev \
# 	    lapack \
# 	    cmake
RUN apt-get update && apt-get install -y git \
    dpkg-dev make g++ gcc binutils libx11-dev \
    libxpm-dev libxft-dev libxext-dev python-dev gfortran \
    cmake python-pip wget

RUN pip install numpy scipy ipython jupyter

# RUN apt-get update && apt-get install -qq -y epel-release gcc curl make \
#                    readline-devel openssl \
#                    openssl-devel patch libjpeg libpng12 libX11 \
#                    which libXpm libXext curlftpfs wget libgfortran file \
#                    fpm rpm-build \
#                    ncurses-devel \
#                    libXt-devel \
#                    gfortran \
#                    perl-ExtUtils-MakeMaker \
#                    net-tools strace sshfs sudo iptables \
# 		   git cmake\
# 		   gcc-gfortran\
# 		   pcre-devel mesa-libGL-devel mesa-libGLU-devel\
# 		   glew-devel ftgl-devel fftw-devel \
# 		   python-devel\
# 		   libxml2-devel gsl-static compat-gcc-44 compat-gcc-44-c++ compat-gcc-44-c++.gfortran\
# 		   python-pip atlas-devel lapack-devel blas-devel


# RUN apk add --no-cache epel-release gcc git curl make zlib-devel bzip2 bzip2-devel \
#                    readline-devel sqlite sqlite-devel openssl \
#                    openssl-devel patch libjpeg libpng12 libX11 \
#                    which libXpm libXext curlftpfs wget libgfortran file \
#                    ruby-devel fpm rpm-build \
#                    ncurses-devel \
#                    libXt-devel \
#                    gcc gcc-c++ gcc-gfortran \
#                    perl-ExtUtils-MakeMaker \
#                    net-tools strace sshfs sudo iptables \
# 		   git cmake gcc-c++ gcc binutils libX11-devel\
# 		   libXpm-devel libXft-devel libXext-devel gcc-gfortran\
# 		   openssl-devel pcre-devel mesa-libGL-devel mesa-libGLU-devel\
# 		   glew-devel ftgl-devel mysql-devel fftw-devel cfitsio-devel\
# 		   graphviz-devel avahi-compat-libdns_sd-devel libldap-dev python-devel\
# 		   libxml2-devel gsl-static compat-gcc-44 compat-gcc-44-c++ compat-gcc-44-c++.gfortran\
# 		   python-pip atlas-devel lapack-devel blas-devel



WORKDIR /opt/

ENV ROOTSYS="/opt/root/"
ENV PATH="$ROOTSYS/bin:$PATH"
ENV LD_LIBRARY_PATH="$ROOTSYS/lib:$LD_LIBRARY_PATH"



RUN cd /opt && wget https://root.cern.ch/download/root_v5.34.36.source.tar.gz &&\
    tar xvzf root_v5.34.36.source.tar.gz &&\
    rm -f root_v5.34.36.source.tar.gz
RUN cd root && mkdir root_build
WORKDIR /opt/root_build
RUN cmake -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_C_COMPILER=gcc \
    -Dfail-on-missing=ON \
    -Dminuit2=ON \
    -Dbuiltin_zlib=ON \
    -Dminimal=ON \
    -Dtmva=OFF \
    -Dmathmore=OFF \
    -Dpython=ON \
    -Dopengl=OFF \
    -Droofit=OFF \
    -Dxml=OFF \
    -Dssl=OFF \
    -Dcastor=OFF \
    -Dmysql=OFF \
    -Doracle=OFF \
    -Dpgsql=OFF \
    -Dsqlite=OFF \
    -Dpythia6=OFF \
    -Dpythia8=OFF \
    -Dfftw3=OFF \
    -Dxrootd=OFF \
    -Dgfal=OFF \
    -Ddavix=OFF \
    -Dfitsio=OFF \
    -Dx11=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/root  ../root && \
     make && make install && cd ..  		  


ENV PATH=$ROOTSYS/bin:$PATH
ENV PYTHONDIR=$ROOTSYS
ENV LD_LIBRARY_PATH=$ROOTSYS/lib:$PYTHONDIR/lib:$ROOTSYS/bindings/pyroot:$LD_LIBRARY_PATH
ENV PYTHONPATH=$ROOTSYS/lib:$PYTHONPATH:$ROOTSYS/bindings/pyroot
RUN apt-get install -y libblas-dev liblapack-dev 

RUN pip install root_numpy
