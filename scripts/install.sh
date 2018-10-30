#!/bin/sh
if [ ! -d ~/bin/ ]; then
    mkdir -p ~/bin/
fi

files=`ls | grep -v install`
for file in $files
do
    cp $file ~/bin/
done

if [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
    echo "User bin path is correctly set"
else
    echo "Mssing "$HOME/bin" in path, need to add it."
fi

