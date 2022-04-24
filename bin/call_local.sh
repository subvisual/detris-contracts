#!/usr/bin/env bash
contract_address=$1
signature=$2
args=${@:3}

echo $contract_address
echo $signature
echo $args

cast call $contract_address "$signature" $args --private-key $PRIVATE_KEY --rpc-url "http://localhost:8545"
