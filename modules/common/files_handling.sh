#!/bin/bash

function func_encode_image() {
    local _image_path=$1

    $(chmod 775 $_image_path)

    #image_extension="$(file -b $image_path | awk '{print $1}')"

    image_extension=$(echo "branding/logo.png" | awk -F . '{print $NF}' | awk '{print toupper($0)}')

    if [ $(func_is_image_valid $image_extension) = "False" ]; then
        echo "Image extension '$image_extension' of an '$_image_path' not supported."
        exit 1
    fi

    #echo "Image extension '$image_extension' of '$image_path' ....."
    local image_prefix="data:image/png;base64,"
    echo | base64 -w0 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        # GNU coreutils base64, '-w' supported
        local encoded_image="$(base64 -w 0 $_image_path)"
        #local encoded_image="$(openssl base64 -A -in $image_path)"
    else
        # MacOS Openssl base64, no wrapping by default
        local encoded_image="$(base64 $_image_path)"
    fi

    echo "${image_prefix} ${encoded_image}"
}

function func_is_image_valid() {
    local _image_extension=$1

    declare -a image_extension_collection=("JPG" "JPEG" "PNG")

    if [[ ${image_extension_collection[$_image_extension]} ]]; then echo "True"; else "False"; fi
}

function func_find_file_by_name() {
    local _image_name=$1

    result=$(find ./branding -name "*${_image_name}*.[png|jpg|jpeg]*" | head -n 1)

    echo $result
}

function func_copy_file_and_replace_values() {
    local _file_path=$1
    local _temp_folder=$2
    
    local _image_background_path=$3
    local _image_logo_path=$4

    local _application_name=$5
    local _database_name=$6

    # make a temp file
    fileName="$(basename -- $_file_path)"
    mkdir -p "$_temp_folder" && cp -r $_file_path ./$_temp_folder/$fileName

    if [ "$_enable_branding" = "true" ]; then

        encodedBackgroundImageUrl="$(func_encode_image $_image_background_path)"
        encodedLogoImageUrl="$(func_encode_image $_image_logo_path)"

        echo "\"$encodedBackgroundImageUrl\"" >"${_temp_folder}/backgroundImage.txt"
        echo "\"$encodedLogoImageUrl\"" >"${_temp_folder}/logoImage.txt"

        # replace background picture
        sed -i.bkp -e "/${templateBackgroundImageName}/r ./${_temp_folder}/backgroundImage.txt" -e "/${templateBackgroundImageName}/d" "${_temp_folder}/${fileName}"

        # replace logo
        sed -i.bkp -e "/${templatLogoImageName}/r ./${_temp_folder}/logoImage.txt" -e "/${templatLogoImageName}/d" "${_temp_folder}/${fileName}"
    fi

    # replace application and database name
    sed -i.original -e "s/${templateAppName}/${_application_name}/g; s/${templateDBName}/${_database_name}/g" "${_temp_folder}/${fileName}"

    # return full file path
    echo "${_temp_folder}/${fileName}"
}