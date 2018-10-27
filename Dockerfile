#
# This Dockerfile builds a recent curl with HTTP/2 client support, using
# a recent nghttp2 build.
#
# See the Makefile for how to tag it. If Docker and that image is found, the
# Go tests use this curl binary for integration tests.
#

FROM jupyter/tensorflow-notebook
USER root

# Install Ruby
RUN apt-get update && \
    sudo apt install -y libtool libffi-dev ruby ruby-dev make

RUN apt-get update && \
    sudo apt install -y libzmq3-dev libczmq-dev

RUN gem install cztop iruby && \
    iruby register --force

# Certbot
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:certbot/certbot && \
    apt-get update

RUN apt-get install -y certbot

# Update Tensorflow
RUN conda update -n base conda && \
    conda update tensorflow

# Tensorboard plugin
# RUN pip install jupyter-tensorboard

# Other Python libraries
RUN pip install pyfunctional

RUN apt-get install -y curl

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y
