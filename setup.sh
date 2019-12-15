#!/bin/bash

############################
# Functions definition
############################
function usage() {
    printf "\nUsage: $0 <blockchain> <network> <validator>\n"
}

function displayBlockchains() {
    printf "\nList of available blockchains:\n"
    printf "%s\n" ./blockchains/*/ | cut -d "/" -f 3
    printf "\n"
}

function displayNetworks() {
    printf "\nList of available networks for $1:\n"
    printf "%s\n" ./blockchains/$1/*/ | cut -d "/" -f 4
    printf "\n"
}

function displayValidators() {
    printf "\nList of validators for $1 $2:\n"
    printf "%s\n" ./blockchains/$1/$2/validators/* | cut -d "/" -f 6
    printf "\n"
}

function sectionLog() {
    printf "\n"
    echo $1
    printf "#################################################\n"
}

############################
# Check parameters
############################
   
# blockchain param is not present
if [ $# -eq 0 ]; then
    printf "\nBlockchain parameter is mandatory."
    usage
    displayBlockchains
    exit 1
fi

# blockchain param is present but invalid
if [ $# -gt 0 ] && ! test -d "./blockchains/$1"; then
    printf "\nBlockchain $1 is not configured.\n"
    displayBlockchains
    exit 1
fi

# network param is not present
if [ $# -eq 1 ]; then
    printf "\nNetwork parameter is mandatory."
    usage
    displayNetworks $1
    exit 1
fi

# network param is present but invalid
if [ $# -gt 1 ] && ! (test -d "./blockchains/$1/$2" && test -f "./blockchains/$1/$2/start.sh"); then
    printf "\nNetwork $2 is not configured."
    displayNetworks $1
    exit 1
fi

# validator param is not present
if [ $# -eq 2 ]; then
    printf "\nValidator parameter is mandatory."
    usage
    displayValidators $1 $2
    exit 1
fi

# validator param is present but invalid
if [ $# -gt 2 ] && ! test -f "./blockchains/$1/$2/validators/$3"; then
    printf "\nValidator $3 is not configured."
    displayValidators $1 $2
    exit 1
fi

############################
# Do the magic
############################
# setup instance file
printf "$1 $2 $3" > validator.instance

# decrypt files
sectionLog "Decrypting $3 files..."
mkdir -p ./tmp
gpg -o ./tmp/$3.json --decrypt ./blockchains/$1/$2/validators/$3
python ./scripts/files.py ./tmp/$3.json
rm -rf ./tmp

# run run blockchain specific setup
if test -f "./blockchains/$1/setup.sh"; then
    sectionLog "Running $1 setup"
    sh ./blockchains/$1/setup.sh
fi

# run network specific setup
if test -f "./blockchains/$1/$2/setup.sh"; then
    sectionLog "Running $2 setup"
    sh ./blockchains/$1/$2/setup.sh
fi

# start validator
sectionLog "Starting $3 on $1 $2"
sh ./blockchains/$1/$2/start.sh