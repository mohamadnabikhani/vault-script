#!/bin/bash

while getopts "f:a:r:d:" opt; do
   case "$opt" in
   f) INPUT_FILE="$OPTARG" ;;
   a) ACTION="$OPTARG" ;; # dec enc
   r) REMOVE_INPUT="$OPTARG" ;; # true false
   d) DESTINATION_PATH="$OPTARG" ;; # true false
   *) echo "unknown flag!" ;;
   esac
done

: "${INPUT_FILE:=""}"
: "${ACTION:=""}"
: "${REMOVE_INPUT:="false"}"
: "${DESTINATION_PATH:="."}"

if [ -z "$ACTION" ]; then
    echo "ACTION is empty or unset, use ./vault.sh -a [dec|enc] -f INPUT_FILE [-r REMOVE_INPUT]"
    exit 1
fi

if [ -z "$INPUT_FILE" ]; then
    echo "INPUT_FILE is empty or unset, use ./vault.sh -a [dec|enc] -f INPUT_FILE [-r REMOVE_INPUT]"
    exit 1
fi

read -s -p "Enter the decryption password: " password
echo

dec (){
    name=$(basename "$INPUT_FILE" .encrypted)
    output_file="${DESTINATION_PATH}/decrypted_files/${name}"
    mkdir -p "${DESTINATION_PATH}/decrypted_files"
    echo -n "$password" | /usr/bin/openssl enc -d -aes-256-cbc -in "$INPUT_FILE" -out "$output_file" -pass stdin

    if [ $? -eq 0 ]; then
        echo "Decryption successful. The decrypted file is: $output_file"
    else
        echo "Decryption failed. Please check the input file or password."
    fi
}

dec-cat-rm (){
    name=$(basename "$INPUT_FILE" .encrypted)
    mkdir -p "${DESTINATION_PATH}/decrypted_files"
    echo -e "\nContent of the file:\n---------\n\n"
    echo -n "$password" | /usr/bin/openssl enc -d -aes-256-cbc -in "$INPUT_FILE" -pass stdin
    echo -e "\n\n\n\n---------"
}

enc (){
    output_file="${DESTINATION_PATH}/encrypted_files/${INPUT_FILE}.encrypted"
    mkdir -p "${DESTINATION_PATH}/encrypted_files"
    echo -n "$password" | openssl enc -aes-256-cbc -salt -in "$INPUT_FILE" -out "$output_file" -pass stdin

    if [ $? -eq 0 ]; then
        echo "Encryption successful. The encrypted file is: $output_file"
    else
        echo "Encryption failed. Please check the input file or password."
    fi
    echo "REMOVE_INPUT is ${REMOVE_INPUT}"
    if [ "$REMOVE_INPUT" = "true" ]; then
        rm -rf ${INPUT_FILE}
    fi

}

if [ "$ACTION" = "dec" ]; then
  echo "start decrypting file: ${INPUT_FILE}"
  dec
  echo "end decrypting"
elif [ "$ACTION" = "enc" ]; then
  echo "start encrypting file: ${INPUT_FILE}"
  enc
  echo "end encrypting"
elif [ "$ACTION" = "cat" ]; then
  echo "start decrypting file: ${INPUT_FILE}"
  dec-cat-rm
  echo "end decrypting"
fi