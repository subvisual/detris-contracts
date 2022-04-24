#!/usr/bin/env bash

if [ -z "${@:2}" ]
then
  forge create ./src/${1}.sol:${1} --private-key $PRIVATE_KEY --rpc-url $ETH_TESTNET_RPC_URL --chain rinkeby
else
  forge create ./src/${1}.sol:${1} --private-key $PRIVATE_KEY --rpc-url $ETH_TESTNET_RPC_URL --chain rikeby --constructor-args ${@:2}
fi
