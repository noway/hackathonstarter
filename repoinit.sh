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

npm i express
npm i -D @types/express
git add .
git commit -m 'add express'

npm i ts-node
echo '{}' > tsconfig.json
jq '.scripts.start = "ts-node --transpile-only index.ts"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add ts-node and start script'

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

npm i ts-node-dev
jq '.scripts.dev = "tsnd --transpile-only --respawn --rs index.ts"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add ts-node-dev and dev script'
