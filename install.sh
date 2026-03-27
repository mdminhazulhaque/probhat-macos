#!/bin/sh

set -e

DEST="/Library/Keyboard Layouts"

if [ ! -d "$DEST" ]; then
    echo "Error: $DEST does not exist"
    exit 1
fi

cd "$DEST"
sudo rm -f Probhat.keylayout
sudo rm -f Probhat.icns
sudo curl -f -O# https://raw.githubusercontent.com/mdminhazulhaque/probhat-macos/master/Probhat.keylayout
sudo curl -f -O# https://raw.githubusercontent.com/mdminhazulhaque/probhat-macos/master/Probhat.icns

echo "Probhat keyboard layout installed successfully. Please reboot to apply changes."
