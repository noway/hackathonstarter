#!/bin/bash
set -ex
KEY="$1"
EC2IP="$2"
REPO="$3"
. .env
if [ -z "$(ssh-keygen -F $EC2IP)" ]; then
  ssh-keyscan -H $EC2IP >> ~/.ssh/known_hosts
fi
ssh -i "$KEY" ec2-user@"$EC2IP" sudo bash -s "$PAT" "$REPO" < ec2init.sh
