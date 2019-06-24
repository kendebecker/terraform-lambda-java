#!/usr/bin/env bash

mvn clean install
cd terraform
echo yes | terraform apply



