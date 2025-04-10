#!/bin/bash

set -e

ENV_DIR="$HOME/.wdpassport-env"
REPO_DIR="$ENV_DIR/wdpassport-utils"
REPO_URL="https://github.com/0-duke/wdpassport-utils.git"

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

check_python() {
    if ! command -v python3 >/dev/null 2>&1; then
        error_exit "python3 not found! Please install Python 3."
    fi
    if ! python3 -m venv --help >/dev/null 2>&1; then
        error_exit "Python venv module not available! Install 'python3-venv' package."
    fi
}

setup_virtualenv() {
    if [ ! -d "$ENV_DIR" ]; then
        echo "Creating virtual environment at $ENV_DIR..."
        python3 -m venv "$ENV_DIR"
    fi
    source "$ENV_DIR/bin/activate"

    echo "Installing dependencies into virtual environment..."
    pip install --upgrade pip wheel pyudev
    pip install --upgrade git+https://github.com/crypto-universe/py_sg.git
}

clone_repo() {
    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning wdpassport-utils repository..."
        git clone "$REPO_URL" "$REPO_DIR"
    fi
}

find_wd_device() {
    echo "Trying to auto-detect WD Passport device using lshw..."

    if ! command -v lshw >/dev/null 2>&1; then
        error_exit "lshw command not found! Please install lshw package."
    fi

    # Grab the first logical name after seeing `product: My Passport`
    DEVICE=$(sudo lshw -class disk -quiet 2>/dev/null | awk '
        BEGIN { found=0 }
        /product: My Passport/ { found=1 }
        found && /logical name:/ {
            print $3
            exit
        }
    ')

    if [ -n "$DEVICE" ]; then
        echo "Auto-detected WD Passport device: $DEVICE"
    else
        error_exit "Could not auto-detect WD Passport device. Please specify manually."
    fi
}

prompt_details() {
    read -rp "Enter the device path (e.g., /dev/sdX) [Press Enter to auto-detect]: " DEV
    if [ -z "$DEV" ]; then
        find_wd_device
    else
        DEVICE="$DEV"
    fi
}

unlock_drive() {
    echo "Unlocking drive $DEVICE..."

    # Use -u to unlock the drive
    python3 "$REPO_DIR/wdpassport-utils.py" -u -d "$DEVICE"
}

check_python
setup_virtualenv
clone_repo
prompt_details
unlock_drive

deactivate
echo "Done!"
