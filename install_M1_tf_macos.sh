#!/bin/sh

conda install numpy six matplotlib opencv

wget https://github.com/apple/tensorflow_macos/releases/download/v0.1alpha2/tensorflow_macos-0.1alpha2.tar.gz
tar xvzf tensorflow_macos-0.1alpha2.tar.gz
env="$HOME/miniforge3/envs/tf"
libs="$PWD/tensorflow_macos/arm64/"
pip install --upgrade -t "$env/lib/python3.8/site-packages/" --no-dependencies --force "$libs/grpcio-1.33.2-cp38-cp38-macosx_11_0_arm64.whl"
pip install --upgrade -t "$env/lib/python3.8/site-packages/" --no-dependencies --force "$libs/h5py-2.10.0-cp38-cp38-macosx_11_0_arm64.whl"
pip install --upgrade -t "$env/lib/python3.8/site-packages/" --no-dependencies --force "$libs/tensorflow_addons_macos-0.1a2-cp38-cp38-macosx_11_0_arm64.whl"
conda install -c conda-forge -y absl-py
conda install -c conda-forge -y astunparse
conda install -c conda-forge -y gast
conda install -c conda-forge -y opt_einsum
conda install -c conda-forge -y termcolor
conda install -c conda-forge -y typing_extensions
conda install -c conda-forge -y wheel
conda install -c conda-forge -y typeguard
pip install wrapt flatbuffers tensorflow_estimator google_pasta keras_preprocessing protobuf
pip install tensorboard
pip install --upgrade -t "$env/lib/python3.8/site-packages/" --no-dependencies --force "$libs/tensorflow_macos-0.1a2-cp38-cp38-macosx_11_0_arm64.whl"
