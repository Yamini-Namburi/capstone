#!/usr/bin/env bash

UUID="$(uuidgen)"

aws cloudformation create-stack --stack-name capstoneudacity$UUID --template-body file://network-server.yml \
--parameters file://network-server-params.json --region=eu-west-1

