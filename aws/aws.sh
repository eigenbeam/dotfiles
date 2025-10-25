#!/bin/bash

echo "Installing AWS Session Manager"
mkdir -p ~/tools/aws-session-manager
cd ~/tools/aws-session-manager
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg" -o "session-manager-plugin.pkg"
sudo installer -pkg session-manager-plugin.pkg -target /
sudo ln -s /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin

echo "Installed AWS Session Manager"
