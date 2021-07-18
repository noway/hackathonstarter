#!/bin/bash
set -ex
export PAT="$1"
export REPO="$2"
export DIRNAME="$(basename $REPO)"
export PUBLIC_HOSTNAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname)"
export PUBLIC_IPV4="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
export TITLE="ec2-user@$(hostname) ($PUBLIC_HOSTNAME)"
curl -fsSL https://rpm.nodesource.com/setup_current.x | bash -
curl -fsSL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
yum install -y git nodejs htop yarn jq
npm install -g pm2
declare -A arches=( ["x86_64"]="amd64" ["aarch64"]="arm64")
wget "https://caddyserver.com/api/download?os=linux&arch=${arches[$(arch)]}" -O /usr/bin/caddy
chmod +x /usr/bin/caddy
groupadd --system caddy || true
useradd --system --gid caddy --create-home \
  --home-dir /var/lib/caddy --shell /usr/sbin/nologin \
  --comment "Caddy web server" caddy || true
wget https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service -O /etc/systemd/system/caddy.service
mkdir -p /etc/caddy
cat > /etc/caddy/Caddyfile <<- EOF
$PUBLIC_HOSTNAME $PUBLIC_IPV4.nip.io $PUBLIC_IPV4.xip.io $PUBLIC_IPV4
reverse_proxy localhost:3001
EOF
systemctl daemon-reload
systemctl enable caddy
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

REPO_PUBLIC_KEY_STR="$(curl \
  -H "Authorization: token $PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$REPO/actions/secrets/public-key)"
REPO_PUBLIC_KEY="$(echo "$REPO_PUBLIC_KEY_STR" | jq -r .key)"
REPO_PUBLIC_KEY_ID="$(echo "$REPO_PUBLIC_KEY_STR" | jq -r .key_id)"
SSH_PRIVATE_KEY="$(cat .ssh/id_ed25519)"
ENCRYPTED_SECRET="$(sudo -u ec2-user npx -y gh-actions-encrypt-secret "$REPO_PUBLIC_KEY" "$SSH_PRIVATE_KEY\n")"
curl \
  -X PUT \
  -H "Authorization: token $PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$REPO/actions/secrets/SSH_PRIVATE_KEY \
  -d "{\"encrypted_value\": \"$ENCRYPTED_SECRET\", \"key_id\": \"$REPO_PUBLIC_KEY_ID\"}"

sudo -u ec2-user git clone "git@github.com:$REPO.git"
cd "$DIRNAME/"
sudo -u ec2-user yarn --frozen-lockfile --prod
sudo -u ec2-user pm2 start yarn --interpreter bash --name "$DIRNAME" -- prod
echo "https://$PUBLIC_IPV4"
echo "https://$PUBLIC_HOSTNAME"