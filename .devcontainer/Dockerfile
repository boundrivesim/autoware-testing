FROM ubuntu:20.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
    sudo \
    git \
    tar curl wget zip unzip gnupg2 \
    python3-pip \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN groupadd work -g 1000 \
   && useradd -ms /bin/bash bouncmpe -g 1000 -u 1000 \
   && printf "bouncmpe:bouncmpe" | chpasswd \
   && printf "bouncmpe ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

USER bouncmpe
WORKDIR /home/bouncmpe

RUN python3 -m pip install --user ansible
ENV PATH=$HOME/.local/bin:$PATH