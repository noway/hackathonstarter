#!/bin/bash
set -ex
KEY="~/.ssh/devtest2020.pem"
EC2IP="54.252.251.201"
REPO="noway/thisprimedoesnotexist"
. .env
ssh -i "$KEY" ec2-user@"$EC2IP" sudo bash -s "$PAT" "$REPO" < ec2init.sh
