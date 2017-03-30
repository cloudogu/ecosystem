#!/bin/bash

# Function calculates number of bit in a netmask
#
mask2cidr() {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7 ; break ;;
            252) let nbits+=6 ; break ;;
            248) let nbits+=5 ; break ;;
            240) let nbits+=4 ; break ;;
            224) let nbits+=3 ; break ;;
            192) let nbits+=2 ; break ;;
            128) let nbits+=1 ; break ;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}

## main ##
# MASK=255.255.254.0
MASK=$1
numbits=$(mask2cidr $MASK)
echo "$numbits"
exit 0
