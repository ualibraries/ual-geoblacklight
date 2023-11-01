#!/bin/bash

docker compose down -v

FILES=`git clean -fdxn`
if [ -n "${FILES}" ]; then
    echo -ne "Do you want to remove the following files? (y|n) \n"
    echo "${FILES}"
    read option
    if [ "$option" == "y" ]; then
        git clean -fdx
    elif [ "$option" == "n" ]; then
        echo -e "\nNot removing any untracked files.\n"
    else
        echo -e "\nSorry, I could not understand the input.\n"
    fi
else
    echo -e "\nNo untracked files were found.\n"
    exit 0
fi