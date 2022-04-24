#/usr/bin/env bash

find ./src/ -type f -name "*.sol" -exec sed -E -i 's/[0-9]+\.[0-9]+\.[0-9]+/'$1'/1' {} \;
