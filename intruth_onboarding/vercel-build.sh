#!/bin/bash
# Exit on error
set -e

# Define Flutter version
FLUTTER_VERSION="3.22.2"

# Go to a temporary directory
cd /tmp

# Download and unzip Flutter
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

# Add Flutter to PATH
export PATH="$PATH:/tmp/flutter/bin"

# Go back to the source code directory Vercel uses
cd $OLDPWD

# Run flutter doctor to verify the install
echo "Running flutter doctor..."
flutter doctor -v

# Run the actual build command
echo "Running flutter build web..."
flutter build web 