#!/bin/bash

# Run this to generate config files (one for now)
# The config files are gitignored and meant to hold
# variables for data we don't want checked into the repo

TEMPLATE_FILE="./Res/Config.template.xcconfig"
CONFIG_FILE="./Res/Config.xcconfig"

# Check if the template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Template file '$TEMPLATE_FILE' does not exist."
    exit 1
fi

# Copy the template to Debug and Release configurations
cp "$TEMPLATE_FILE" "$CONFIG_FILE"
echo "Copied to '$CONFIG_FILE'. Open in xcode and fill in the values"
