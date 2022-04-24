#!/usr/bin/env bash

if [ -z "${@:2}" ]
then
  forge create ./src/${2}.sol:${2}  --rpc-url $ETH_MAINNET_RPC_URL
else
  forge create ./src/${2}.sol:${2}  --rpc-url $ETH_MAINNET_RPC_URL --constructor-args ${@:2}
fi
