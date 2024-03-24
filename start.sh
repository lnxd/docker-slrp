#!/bin/bash

echo "- Preparing slrp"

# Download the latest release from GitHub
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH_SUFFIX="amd64"
        ;;
    aarch64)
        ARCH_SUFFIX="arm64"
        ;;
    *)
        echo "- Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
echo "- Found supported architecture: $ARCH"

ASSETS=$(curl -s "https://api.github.com/repos/lnxd/slrp/releases/latest" | grep '"browser_download_url":')

DOWNLOAD_URL=$(echo "$ASSETS" | grep "linux_${ARCH_SUFFIX}" | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Failed to find a matching asset for download"
    exit 1
fi

FILENAME=$(basename "$DOWNLOAD_URL")

echo "- Downloading $DOWNLOAD_URL"
wget -q "$DOWNLOAD_URL" -O "/tmp/${FILENAME}"
if [ $? -ne 0 ]; then
    echo "- Download failed, quitting"
    exit 1
fi

# Prepare and extract the binary
TARGET_DIR="/home/docker/slrp"
if [ -d "$TARGET_DIR" ]; then
    echo "- Emptying $TARGET_DIR"
    rm -rf "$TARGET_DIR"/*
fi

mkdir -p "$TARGET_DIR"

echo "- Extracting $FILENAME to $TARGET_DIR"
tar -xzf "/tmp/${FILENAME}" -C "$TARGET_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to extract $FILENAME"
    exit 1
fi

echo "- Setting execute permissions on the binary"
sudo chmod +x "$TARGET_DIR/slrp"

# Launch binary with signal handling
term_handler() {
  if pidof slrp >/dev/null; then
    echo "- Terminating slrp"
    kill -SIGTERM $(pidof slrp)
  fi
  exit 143; # SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

echo "- Starting slrp binary"
"$TARGET_DIR/slrp" &
slrp_pid="$!"

wait $slrp_pid

echo "- Setup completed successfully."
