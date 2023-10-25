#!/bin/bash

env USER_GID=$(id -g) USER_UID=$(id -u) docker compose down -v

echo -ne "Do you want to remove the following files? (y|n) \n"
git clean -fdxn
read option
if [ "$option" == "y" ]; then
    git clean -fdx
elif [ "$option" == "n" ]; then
    echo -e "\nNot removing any untracked files.\n"
else 
    echo "Sorry, I could not understand the input, so no files were removed."
fi