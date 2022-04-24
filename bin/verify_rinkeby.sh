#!/usr/bin/env bash
version=$(grep "\d+\.?\d*.?\d*" hardhat.config.js)
contract=$1
deployed=$2

if [ -z "${@:3}" ]
then
  forge verify-contract --compiler-version v$version $deployed ./src/${contract}.sol:${contract} $ETHERSCAN_API_KEY --chain-id 4
else
  forge verify-contract --compiler-version v$version $deployed ./src/${contract}.sol:${contract} $ETHERSCAN_API_KEY --constructor-args ${@:3} --chain-id 4
fi
