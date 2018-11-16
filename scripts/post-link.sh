#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
	ruby $(dirname "$0")/post-link-ios.rb
fi

