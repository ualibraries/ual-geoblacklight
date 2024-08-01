#!/bin/bash

docker compose down -v

echo -e "\nDo you want to remove all files in tmp directory, log directory, and sqlite files? (y|n)"
read option
if [ "$option" == "y" ]; then
    rm -rf log/* tmp/cache tmp/sockets tmp/pids/* tmp/miniprofiler db/*.sqlite3 db/*.sqlite3-*
    rm tmp/* 2> /dev/null
elif [ "$option" == "n" ]; then
    echo -e "\n\nNot removing any untracked files. This may have an effect on the next container startup. \n\n"
else
    echo -e "\n\nSorry, I could not understand the input. \n\n"
fi