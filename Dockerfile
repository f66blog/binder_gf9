FROM python:3.7-slim

USER root
ENV GCC_VERSION 9.1.0

RUN apt-get update -y && \
    apt-get install -y apt-utils && \
    apt-get install -y apt-transport-https curl gnupg gnupg2 && \ 
    apt-get install -y --no-install-recommends \
    software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-check-certificate \
    build-essential \
    gcc-9>=9.1.0 \
    gfortran-9>=9.1.0 \
    g++-9>=9.1.0 \
    ${transientBuildDeps} && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-9 && \
    update-alternatives --set gcc "/usr/bin/gcc-9" && \
    gcc --version && \
    gfortran --version && \
    apt-get clean && \
    apt-get purge -y --auto-remove ${transientBuildDeps} && \
    rm -rf /var/lib/apt/lists/* /var/log/* /tmp/*        

# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook      && \
    pip install --no-cache matplotlib    && \
    pip install --no-cache numpy         && \
    pip install --no-cache sympy         && \
    pip install --no-cache pandas        && \
    pip install --no-cache pillow        && \
    pip install --no-cache scipy         && \
    pip install --no-cache jupyter_contrib_nbextensions

ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

USER ${NB_USER}
RUN    cd ${HOME} \
    && git clone https://github.com/f66blog/binder_gf9.git   \
    && cd binder_gf9 \
    && pip install --user ./jupyter-gfort-kernel          \
    && jupyter kernelspec install ./jupyter-gfort-kernel/gfort_spec --user 

WORKDIR ${HOME}/binder_gf9


