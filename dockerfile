# syntax=docker/dockerfile:1

# Force x64/amd64 even when building on Apple Silicon
FROM --platform=linux/amd64 quay.io/centos/centos:stream9

# Avoid interactive prompts
ENV container=docker

# Install C++ development tools
RUN dnf -y update && \
    dnf -y groupinstall "Development Tools" && \
    dnf -y install \
      gcc-c++ \
      clang \
      clang-tools-extra \
      cmake \
#      ninja \
      gdb \
      git \
      make \
      python3 \
      which \
      file \
      procps-ng \
      && \
    dnf clean all && rm -rf /var/cache/dnf

# Create a non-root user for development (optional but recommended)
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd  --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    mkdir -p /workspace && chown -R ${USERNAME}:${USERNAME} /workspace

WORKDIR /workspace
USER ${USERNAME}

# Nice defaults
ENV CC=clang CXX=clang++
