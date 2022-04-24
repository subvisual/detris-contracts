#!/usr/bin/env bash

rm -rf flattened.txt
forge flatten ./src/${1}.sol > flattened.txt
