FROM jupyter/scipy-notebook:cf6258237ff9

USER root
ENV GCC_VERSION 9.1.0

RUN    apt-get update -y \
    && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    gcc-9>=9.1.0 \
    gfortran-9>=9.1.0 \
    g++-9>=9.1.0 \
    ${transientBuildDeps} \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-9 \
    && update-alternatives --set gcc "/usr/bin/gcc-9" \
    && gcc --version \
    && gfortran --version \
    && apt-get clean \
    && apt-get purge -y --auto-remove ${transientBuildDeps} \
    && rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*

RUN    git clone https://github.com/f66blog/fortran8.git \
    && pip install -e ./jupyter-gfort-kernel             \
    && jupyter kernelspec install ./jupyter-gfort-kernel 


ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}


