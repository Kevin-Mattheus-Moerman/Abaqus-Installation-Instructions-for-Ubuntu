#!/bin/sh
for f in $(find $(pwd) -iname "*.sh" -type f); do
        chmod +x $f
done

for f in $(find $(pwd) -type f); do
        chmod +x $f
done
