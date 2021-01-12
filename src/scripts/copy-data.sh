#!/bin/bash

# exit when any command fails
set -e 

# make sure we are logged in
az account show

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export ROOT="$(realpath $DIR/../..)"
export FILE_NAME=inception_v3_2016_08_28.tar.gz
export DATA_PATH=$ROOT/data
export TERRAFORM_PATH=$ROOT/src/terraform
export DOWNLOADED_FILE=$DATA_PATH/$FILE_NAME

# Download and Extract
echo "downloading $FILE_NAME"
wget -O $DOWNLOADED_FILE http://download.tensorflow.org/models/$FILE_NAME
echo "extracting $FILE_NAME to $DATA_PATH"
tar -xf $DOWNLOADED_FILE -C $DATA_PATH
echo "removing $DOWNLOADED_FILE"
rm $DOWNLOADED_FILE

# Upload to azure blob (make sure to run terraform first)
pushd $TERRAFORM_PATH
export AZURE_STORAGE_ACCOUNT=`terraform output -json | jq -r '.data_storage_account_name'`
export AZURE_STORAGE_CONNECTION_STRING=`terraform output -json | jq -r '.data_storage_account_connection_string.value'`
popd

for f in $(ls $DATA_PATH -I .gitignore)
do
    echo "uploading $DATA_PATH/$f"    
    az storage blob upload -c data -f $DATA_PATH/$f -n $f
    rm $DATA_PATH/$f
done