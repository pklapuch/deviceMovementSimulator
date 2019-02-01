#!/bin/sh

######################
# Options
######################

FRAMEWORK_NAME="${PROJECT_NAME}"

UNIVERSAL_OUTPUT_DIR=${BUILD_DIR}/${CONFIGURATION}-universal

RELEASE_DIR=${PROJECT_DIR}/build

######################
# Prepare directories
######################

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUT_DIR}"


######################
# Build
######################

# Step 1. Build Device and Simulator versions
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO BITCODE_GENERATION_MODE=bitcode -configuration ${CONFIGURATION} BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build -sdk iphoneos

xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO BITCODE_GENERATION_MODE=bitcode -configuration ${CONFIGURATION} BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build -sdk iphonesimulator

######################
# Merge
######################

# Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework" "${UNIVERSAL_OUTPUT_DIR}/"

# Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/."
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUT_DIR}/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"
fi

# Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUT_DIR}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

## Convenience step to copy the framework to the project's directory
#cp -R "${UNIVERSAL_OUTPUT_DIR}/${FRAMEWORK_NAME}.framework" "${RELEASE_DIR}"
