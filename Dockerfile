FROM debian:bullseye-slim

# Set environment variable
ENV DEBIAN_FRONTEND=noninteractive

# Install default packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        curl \
        sudo \
        nano \
        git \
        wget \
        zsh \
        tzdata \
        ca-certificates \
    && ln -fs /usr/share/zoneinfo/Australia/Melbourne /etc/localtime \
    && echo "Set disable_coredump false" >> /etc/sudo.conf \
    && useradd docker --no-create-home \
    && echo 'docker:docker' | chpasswd \
    && usermod -aG sudo docker \
    && mkdir -p /home/docker \
    && chsh -s $(which zsh) docker \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define working directory
WORKDIR /home/docker/
