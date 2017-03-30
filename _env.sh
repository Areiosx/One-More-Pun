#!/bin/bash

# Helper functions
pushd () {
    command pushd "$@" > /dev/null
}
popd () {
    command popd "$@" > /dev/null
}

# Go to script directory
pushd "${0%/*}"

echo " * Updating pod environment"
pod repo update
pod install

popd
