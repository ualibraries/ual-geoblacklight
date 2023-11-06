#!/bin/bash

docker compose down -v

FILES=`git clean -fdxn`
if [ -n "${FILES}" ]; then
    echo -e "\n\nThe following files have untracked changes since the last commit, \nusually meaning they are ignored and/or code-generated dependencies. \n\n"
    echo "${FILES} \n\n"
    echo -e "Do you want to remove them? (y|n)"
    read option
    if [ "$option" == "y" ]; then
        git clean -fdx
    elif [ "$option" == "n" ]; then
        echo -e "\n\nNot removing any untracked files. This may have an effect on the next container startup. \n\n"
    else
        echo -e "\n\nSorry, I could not understand the input. \n\n"
    fi
else
    echo -e "\n\nNo untracked files were found. \n\n"
    exit 0
fi