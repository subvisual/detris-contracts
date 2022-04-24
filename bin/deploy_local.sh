#!/usr/bin/env bash

#fork
make mainnet-fork $rpc &
sleep 5

if [ -z "${@:2}" ]
then
  forge create ./src/${2}.sol:${2}  --rpc-url "http://localhost:8545"
else
  forge create ./src/${2}.sol:${2}  --rpc-url "http://localhost:8545" --constructor-args ${@:2}
fi
