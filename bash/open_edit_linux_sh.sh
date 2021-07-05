#!/bin/sh
for f in $(find $(pwd) -name "Linux.sh" -type f); do
        sudo gedit $f
done
