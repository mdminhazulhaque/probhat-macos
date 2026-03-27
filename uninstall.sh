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

echo "Probhat keyboard layout uninstalled successfully. Please reboot to apply changes."
