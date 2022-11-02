FROM ubuntu:20.04 as builder

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
    sudo \
    git \
    tar curl wget zip unzip gnupg2 \
    python3-pip \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN groupadd work -g 1000 \
   && useradd -ms /bin/bash builder -g 1000 -u 1000 \
   && printf "builder:builder" | chpasswd \
   && printf "builder ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

USER builder
WORKDIR /home/builder

RUN python3 -m pip install --user ansible
ENV PATH=/home/builder/.local/bin:$PATH

## Clone build scripts
RUN git clone https://github.com/boundrivesim/autoware-testing

RUN cd autoware-testing && ansible-galaxy install -r requirements.yml
RUN ansible-playbook bouncmpe.autoware.classic_build -e '{ros_distro_type: ros-base}'
