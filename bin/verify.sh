#!/usr/bin/env bash
version=$(grep "\d+\.?\d*.?\d*" hardhat.config.js)
contract=$1
address=$2

if [ -z "${@:3}" ]
then
  forge verify-contract --compiler-version \"$version\" $deployed ./src/${contract}.sol:${contract} $ETHERSCAN_API_KEY
else
  forge verify-contract --compiler-version \"$version\" $deployed ./src/${contract}.sol:${contract} $ETHERSCAN_API_KEY --constructor-args ${@:3}
fi
