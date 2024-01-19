#!/bin/bash

TF_HETZNER_TOKEN=4rygDBAyeudAmt6ZFp3QQs5MIx7nN3U8PUaHGhyybwrBRuvo0vzXyRsJ034vdLvj

if [ ! -d "data" ]; then
    mkdir data
fi

curl -H "Authorization: Bearer $TF_HETZNER_TOKEN" \
  'https://api.hetzner.cloud/v1/images' | jq '.images | map(select(.type == "system" and .architecture == "x86"))' \
  > data/images.json

curl -H "Authorization: Bearer $TF_HETZNER_TOKEN" \
 'https://api.hetzner.cloud/v1/server_types' | jq '.server_types | map(select(.architecture == "x86"))' \
 > data/server_types.json

curl -H "Authorization: Bearer $TF_HETZNER_TOKEN" \
 'https://api.hetzner.cloud/v1/locations' \
 > data/locations.json
