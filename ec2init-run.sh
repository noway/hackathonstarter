#!/bin/bash
set -ex
. .env
KEY="~/.ssh/devtest2020.pem"
EC2IP="13.211.123.26"
REPO="noway/thisprimedoesnotexist"
ssh -i "$KEY" ec2-user@"$EC2IP" sudo bash -s "$PAT" "$REPO" < ec2init.sh
