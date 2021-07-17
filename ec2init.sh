#!/bin/bash
set -ex
export PAT="$1"
export REPO="$2"
export DIRNAME="$(basename $REPO)"
export PUBLIC_HOSTNAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname)"
export PUBLIC_IPV4="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
export TITLE="ec2-user@$(hostname) ($PUBLIC_HOSTNAME)"
amazon-linux-extras install epel -y
curl -fsSL https://rpm.nodesource.com/setup_current.x | bash -
curl -fsSL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
yum install -y git nodejs caddy htop yarn jq
npm install -g pm2
cat > /etc/caddy/caddy.conf <<- EOF
$PUBLIC_HOSTNAME {
  reverse_proxy localhost:3000
}
$PUBLIC_IPV4.nip.io {
  reverse_proxy localhost:3000
}
$PUBLIC_IPV4.xip.io {
  reverse_proxy localhost:3000
}
$PUBLIC_IPV4 {
  reverse_proxy localhost:3000
}
EOF
systemctl start caddy
cd /home/ec2-user
sudo -u ec2-user ssh-keyscan github.com | sudo -u ec2-user tee -a .ssh/known_hosts
sudo -u ec2-user ssh-keygen -t ed25519 -f .ssh/id_ed25519 -P ""
sudo -u ec2-user curl \
  -X POST \
  -H "Authorization: token $PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/keys" \
  -d "{\"key\": \"$(cat .ssh/id_ed25519.pub)\", \"read_only\": false, \"title\": \"$TITLE\"}"
sudo -u ec2-user git clone "git@github.com:$REPO.git"
cd "$DIRNAME/"
sudo -u ec2-user yarn --frozen-lockfile
sudo -u ec2-user pm2 start yarn --name "$DIRNAME" -- start
echo "https://$PUBLIC_IPV4"
echo "https://$PUBLIC_HOSTNAME"