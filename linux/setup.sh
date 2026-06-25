#!/bin/sh
set -eu

cd "$(dirname "$0")"

./system-setup.sh
./user-setup.sh
