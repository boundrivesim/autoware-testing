
ARG BASE_IMAGE="ubuntu:20.04"

# hadolint ignore=DL3006
FROM $BASE_IMAGE as builder
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO="galactic"
ARG SETUP_ARGS=""
ARG AUTOWARE_TAG="main"

## Install apt packages
# hadolint ignore=DL3008

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
    sudo \
    git \
    tar curl wget zip unzip gnupg2 \
    # python3-pip \
    # python3-venv \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

RUN groupadd work -g 1000 \
   && useradd -ms /bin/bash builder -g 1000 -u 1000 \
   && printf "builder:builder" | chpasswd \
   && printf "builder ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

USER builder
WORKDIR /home/builder

## Clone Autoware
RUN git clone --depth 1 --branch $AUTOWARE_TAG https://github.com/autowarefoundation/autoware.git 
WORKDIR /home/builder/autoware

RUN sudo apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get -y install \
    python3-pip \
    python3-venv \
    && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo rm -rf /var/lib/apt/lists/* 

## Install Ansible
RUN pip install --user pipx 
ENV PATH="/home/builder/.local/bin:$PATH"
RUN pipx install --include-deps --force "ansible==6.*"

## Set up development environment
RUN ./setup-dev-env.sh -y --no-dev universe

RUN mkdir src \
    && vcs import src < autoware.repos \
    && rosdep update \
    && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" 

# # hadolint ignore=DL3006
# FROM nvidia/cuda:11.6.2-devel-ubuntu20.04 as prebuilt

# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
#         ros-galactic-ros-base \
#     && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

# ## Copy install folder from builder
# COPY --from=builder /autoware/install/ /opt/autoware/galactic/


# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ARG ROS_DISTRO
# ARG SETUP_ARGS

# ## Install apt packages
# # hadolint ignore=DL3008



# ## Add GitHub to known hosts for private repositories
# RUN mkdir -p ~/.ssh \
#   && ssh-keyscan github.com >> ~/.ssh/known_hosts

# ## Set up runtime environment
# RUN --mount=type=ssh \
#   ./setup-dev-env.sh -y $SETUP_ARGS --no-cuda-drivers --no-dev --ros-install-base universe \
#   && pip uninstall -y ansible ansible-core \
#   && mkdir src \
#   && vcs import src < autoware.repos \
#   && rosdep update \
#   && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" \
#   && rm -rf src \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/*


# ## Clean up unnecessary files
# RUN rm -rf \
#   "$HOME"/.cache \
#   /etc/apt/sources.list.d/cuda*.list \
#   /etc/apt/sources.list.d/docker.list \
#   /etc/apt/sources.list.d/nvidia-docker.list

# ## Register Vulkan GPU vendors
# ADD "https://gitlab.com/nvidia/container-images/vulkan/raw/dc389b0445c788901fda1d85be96fd1cb9410164/nvidia_icd.json" /etc/vulkan/icd.d/nvidia_icd.json
# RUN chmod 644 /etc/vulkan/icd.d/nvidia_icd.json
# ADD "https://gitlab.com/nvidia/container-images/opengl/raw/5191cf205d3e4bb1150091f9464499b076104354/glvnd/runtime/10_nvidia.json" /etc/glvnd/egl_vendor.d/10_nvidia.json
# RUN chmod 644 /etc/glvnd/egl_vendor.d/10_nvidia.json

# ## Create entrypoint
# # hadolint ignore=DL3059
# RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc
# CMD ["/bin/bash"]