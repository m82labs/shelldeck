#!/bin/bash

# Create an associative array to hold our slide deck
declare -A slide_deck
titles=()
width=$(( `tput cols`/2 ))

# Check for a file
p_data=${1}

# Check if it exists
if [ ! -f "${p_data}" ]; then
    echo "File does not exist: ${p_data}"
    exit
fi

# Load our presentation data into an array
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ ${line} == '##'* ]]; then
        current_key="`echo ${line} | sed 's/##//g'`"
        titles+=("${current_key}")
    else
        slide_deck["${current_key}"]+="${line}||||"
    fi
done < "${p_data}"

c_slide=0
while [[ "x${titles[${c_slide}]}" != "x" ]]; do
    key="${titles[${c_slide}]}"

    clear
    figlet -w ${width} "${key}"
    echo "${slide_deck[${key}]}" | sed 's/||||/\n/g'

    key_press='x'
    while [[ "${key_press}" != "a" && "${key_press}" != "s" ]]; do
        read -n1 -s -p '>>' < /dev/tty key_press
    done

    if [[ "${key_press}" == "a" ]]; then
        c_slide=$(( $c_slide - 1 ))
        if [[ "${c_slide}" -lt "0" ]]; then
            c_slide=0
        fi
    else
        c_slide=$(( $c_slide + 1 ))
    fi
    echo ${c_slide}
done
clear
