#!/bin/bash

version="latest"

if [ "x$1" != "x" ]; then
  version="${1}"
fi

image_name="appdynamicscx/configmyapp"

if [ "x$2" != "x" ]; then
  image_name="${2}"
fi

#standard run
docker run --rm --env-file env.list ${image_name}:${version} 

if [ $? -eq 0 ]
then
  echo "Successful Docker container run. Proceeding..."
else
  echo "Error occurred. Could not run the Docker container." >&2
  exit 1
fi

docker ps

# change directory to the root folder where mounted volumes are located - if you're executing the ./run.sh script
#cd ../ && pwd

################ Configure Business transaction  ################
# If you have modified the bt_config/configBT.json file, you'd need to mount the bt_config volume like this: 
#docker run -d \
#  --mount type=bind,source=$(pwd)/bt_config,destination=/opt/configmyapp/bt_config \
#   ${image_name}:${version}
################ END ################

################ Configure Dashboard branding ################

# If you have uploaded your companies logo and a background image to the branding folder, you'd need to mount the branding volume like this. 
#  Please REMEMBER to update the CMA_LOGO_NAME and CMA_BACKGROUND_NAME environment variables with your custom image names. 
#docker run -d \
#  --mount type=bind,source=$(pwd)/branding,destination=/opt/configmyapp/branding \
#  --env-file docker/env.list  ${image_name}:${version}
################ END ################
