#!/bin/sh

source test/setup/server.sh

npx nyc mocha $(dirname $0)/index.js
