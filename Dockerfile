FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# User info
ARG USER=user
ARG GROUP=user
ARG PASS=password

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    bzip2 \
    curl \
    gcc-4.8 \
    g++-4.8 \
    gnupg \
    git \
    less \
    libbz2-dev \
    libssl-dev \
    lsof \
    openssl \
    unzip \
    vim \
    wget

# Install Python
#RUN apt update && apt install -y python-dev python-pip
RUN apt update && apt install -y python3-dev python3-pip
RUN pip3 install -U pip six 'numpy<1.19.0' wheel setuptools mock 'future>=0.17.1'
RUN pip3 install -U keras_applications --no-deps
RUN pip3 install -U keras_preprocessing --no-deps

# Install Bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-installer-linux-x86_64.sh
RUN chmod +x bazel-0.24.1-installer-linux-x86_64.sh
RUN ./bazel-0.24.1-installer-linux-x86_64.sh

# Install Tensorflow
RUN git clone https://github.com/tensorflow/tensorflow.git
WORKDIR tensorflow
RUN git checkout r1.14
ADD .tf_configure.bazelrc .
ENV TMP=/tmp
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
RUN pip3 install /tmp/tensorflow_pkg/tensorflow-*.whl

# Install python library
RUN pip3 install --ignore-installed \
    jupyter \
    graphviz \
    matplotlib \
    notebook \
    pandas \
    h5py \
    pydot \
    scikit-learn \
    SciPy \
    jupyter_contrib_nbextensions

# Enable nbextension
RUN jupyter contrib nbextension install --user
RUN mkdir /opt/notebooks

# Add user
RUN groupadd -g 1000 $GROUP
RUN useradd -g $GROUP -G sudo -m -s /bin/bash $USER

RUN echo "${USER}:${PASS}" | chpasswd
RUN echo "root:${PASS}" | chpasswd

RUN echo 'alias ls="ls -a --color=auto --show-control-chars --time-style=long-iso -FH"' >> /home/$USER/.profile
RUN echo 'alias ll="ls -a -lA"' >> /home/$USER/.profile
RUN echo 'alias h=history' >> /home/$USER/.profile
RUN echo 'alias vi=vim' >> /home/$USER/.profile
RUN echo 'PS1="% "' >> /home/$USER/.bashrc
RUN echo 'set background=dark' > /home/$USER/.vimrc
RUN echo 'syntax on' >> /home/$USER/.vimrc

# Clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

WORKDIR /
EXPOSE 8888

# Run jupyter notebook.
CMD ["jupyter", "notebook", "--notebook-dir=/opt/notebooks", "--ip='*'", "--port=8888", "--no-browser"]
