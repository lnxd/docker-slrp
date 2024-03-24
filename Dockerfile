# Specify base image
FROM debian:bookworm-slim

# Set non-interactive frontend and default timezone
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

# Install default packages, set up environment, and add infinite_sleep script
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        apt-utils curl sudo nano git wget zsh tzdata ca-certificates && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
    echo "Set disable_coredump false" >> /etc/sudo.conf && \
    useradd -m -s $(which zsh) docker && \
    echo 'docker ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/docker && \
    mkdir -p /opt/scripts && \
    printf '%s\n' '#!/bin/sh' 'echo "- Sleeping forever"' 'sleep infinity' > /opt/scripts/infinite_sleep && \
    chmod +x /opt/scripts/infinite_sleep && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Define working directory
WORKDIR /home/docker
