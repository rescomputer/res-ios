#!/bin/bash

# Paths to the template and the new config files
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
