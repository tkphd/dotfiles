#!/bin/bash -e

# Read in a password
# Return its hash

echo "«If you have a pass I will hash it!»: "
read -s PASSWORD

# PASSCONV="$(echo -n "${PASSWORD}" | iconv -t UTF-16LE)"

echo -n "${PASSWORD}" | iconv -t UTF-16LE | openssl md5

# wpa_passphrase NISTNet "${PASSWORD}"

echo
