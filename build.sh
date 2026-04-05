#!/bin/bash
set -e

APP_NAME="Glimpse"
APP_DIR="$APP_NAME.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"
RESOURCES_DIR="$APP_DIR/Contents/Resources"

# Clean up build directories
rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Compile Swift files
swiftc -o "$MACOS_DIR/$APP_NAME" Sources/*.swift -framework SwiftUI -framework AppKit

# Copy Info.plist
cp Info.plist "$APP_DIR/Contents/"

echo "Build complete! Run 'open Glimpse.app' or './$MACOS_DIR/$APP_NAME'"
