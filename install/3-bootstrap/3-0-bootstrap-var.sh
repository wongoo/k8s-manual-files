#!/bin/sh
#

export TOKEN_ID=$(openssl rand 3 -hex)
export TOKEN_SECRET=$(openssl rand 8 -hex)
export BOOTSTRAP_TOKEN=${TOKEN_ID}.${TOKEN_SECRET}

echo $TOKEN_ID
echo $TOKEN_SECRET
echo $BOOTSTRAP_TOKEN

