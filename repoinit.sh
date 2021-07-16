#!/bin/bash
set -ex
DIRNAME="$1"

mkdir $DIRNAME
cd $DIRNAME
npm init -y
git init
jq '.license = "UNLICENSED"' package.json > tmp && mv tmp package.json
jq '.version = "0.0.0"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'initial commit'

echo 'node_modules/' > .gitignore
git add .gitignore
git commit -m 'ignore node_modules'

yarn add express
yarn add -D @types/express
git add .
git commit -m 'add express'

yarn add ts-node
echo '{}' > tsconfig.json
jq '.scripts.prod = "ts-node --transpile-only index.ts"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add ts-node and prod script'

cat > index.ts <<- EOF
import * as express from 'express'
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(\`Example app listening at http://localhost:\${port}\`)
})
EOF
git add .
git commit -m 'add index.ts'

yarn add ts-node-dev
jq '.scripts.start = "ts-node-dev --transpile-only --respawn --rs index.ts"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add ts-node-dev and start script'

cat > README.md <<- EOF
# $DIRNAME

## Available Scripts

In the project directory, you can run:

### \`yarn start\`

Runs the app in the development mode. \
The server will restart when a file is modified.

### \`yarn prod\`

Runs the app in the production mode.
EOF
git add .
git commit -m 'add README.md'
