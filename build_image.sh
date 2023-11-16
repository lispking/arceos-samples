#!/bin/bash

APP_PATH=$(pwd)/../arceos/payload
APP_BIN=apps.bin

# build app to image
build_image() {
    local app_name=$1
    local app_seek=$2

    # Compile Apps
    make APP=${app_name} compile

    # Get App Size
    if [ "$(uname)" == "Darwin" ]; then
        local app_size=$(stat -f%z ./${app_name}/${app_name}.bin)
    else
        local app_size=$(stat -c%s ./${app_name}/${app_name}.bin)
    fi

    # Write App Size to App Bin
    printf "$(printf '%04x' $app_size)" | xxd -p -r | dd of=./${APP_BIN} conv=notrunc bs=1 seek=${app_seek}

    # Write App to App Bin
    local app_seek_file=$(($app_seek + 2))
    dd if=./${app_name}/${app_name}.bin of=./${APP_BIN} conv=notrunc bs=1 seek=${app_seek_file}

    echo "app_name: ${app_name} size: ${app_size} seek: from $app_seek to ${app_seek_file}"
}

# Create App Bin
dd if=/dev/zero of=./${APP_BIN} bs=1M count=32

# Write App Num to App Bin
APP_NUM=2
printf "$(printf '%04x' ${APP_NUM})" | xxd -p -r | dd of=./${APP_BIN} conv=notrunc bs=1 seek=0

if [ "$1" == "ch3" ]; then
    build_image hello_app_v3 2
    build_image hello_app_v1 8
else
    build_image hello_app_v1 2
    build_image hello_app_v2 10
fi

mkdir -p ${APP_PATH}
mv ./${APP_BIN} ${APP_PATH}/${APP_BIN}
echo "build image: ${APP_PATH}/${APP_BIN} done"
