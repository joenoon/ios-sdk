#!/bin/sh

set -e
 
# If we're already inside this script then die
if [ -n "$YSG_BUILD_IN_PROGRESS" ]; then
  exit 0
fi
export YSG_BUILD_IN_PROGRESS=1

echo "Building static library..."

xcodebuild -workspace "YesGraph/YesGraph.xcworkspace" -scheme "YesGraphSDKStatic" \
					ONLY_ACTIVE_ARCH=NO \
					CONFIGURATION_BUILD_DIR=../../Build/static \
			-configuration Release

echo "Building framework..."

xcodebuild -workspace "YesGraph/YesGraph.xcworkspace" -scheme "YesGraphSDK" \
					ONLY_ACTIVE_ARCH=NO \
					CONFIGURATION_BUILD_DIR=../../Build/framework \
			-configuration Release

echo "All done."