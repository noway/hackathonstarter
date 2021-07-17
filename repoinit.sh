#!/bin/bash
set -ex
DIRNAME="$1"

mkdir $DIRNAME
cd $DIRNAME
git init
echo '{}' > package.json
jq ".name = \"$DIRNAME\"" package.json > tmp && mv tmp package.json
jq ".version = \"0.1.0\"" package.json > tmp && mv tmp package.json
jq ".private = true" package.json > tmp && mv tmp package.json
jq ".description = \"\"" package.json > tmp && mv tmp package.json
jq ".scripts = {}" package.json > tmp && mv tmp package.json
jq ".keywords = []" package.json > tmp && mv tmp package.json
jq ".author = \"\"" package.json > tmp && mv tmp package.json
jq ".license = \"UNLICENSED\"" package.json > tmp && mv tmp package.json
git add .
git commit -m 'initial commit'

echo 'node_modules/' > .gitignore
git add .gitignore
git commit -m 'ignore node_modules'

yarn add express
yarn add -D @types/express
git add .
git commit -m 'add express'

yarn add ts-node-dev typescript
jq '.scripts.start = "ts-node-dev --transpile-only --respawn --rs index.ts"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add ts-node-dev and start script'

cat > index.ts <<- EOF
import * as express from 'express'

const app = express()
const port = 3001

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(\`Example app listening at http://localhost:\${port}\`)
})
EOF
git add .
git commit -m 'add index.ts'

yarn add -D @types/node
yarn add ts-node
echo '{}' > tsconfig.json
jq '.scripts.prod = "ts-node --transpile-only index.ts"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add ts-node and prod script'

cat > README.md <<- EOF
# $DIRNAME

## Available Scripts

In the project directory, you can run:

### \`yarn start\`

Runs the app in the development mode.\\
The server will restart when a file is modified.

### \`yarn prod\`

Runs the app in the production mode.

### \`yarn lint\`

Lints all JavaScript and TypeScript files.
EOF
git add .
git commit -m 'add README.md'

yarn add -D eslint typescript @typescript-eslint/parser @typescript-eslint/eslint-plugin
echo 'node_modules/' > .eslintignore
cat > .eslintrc.json <<- EOF
{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "project": "./tsconfig.json"
  },
  "plugins": [],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking"
  ],
  "env": {
    "node": true
  }
}
EOF
jq '.scripts.lint = "eslint . --ext .js,.jsx,.ts,.tsx"' package.json > tmp && mv tmp package.json
git add .
git commit -m 'add eslint and eslint config'


yarn add -D eslint-plugin-eslint-comments
yarn add -D eslint-plugin-import
yarn add -D eslint-plugin-node
yarn add -D eslint-plugin-promise

jq '.extends += ["plugin:eslint-comments/recommended"]' .eslintrc.json > tmp && mv tmp .eslintrc.json
jq '.extends += ["plugin:import/recommended"]' .eslintrc.json > tmp && mv tmp .eslintrc.json
jq '.extends += ["plugin:node/recommended-module"]' .eslintrc.json > tmp && mv tmp .eslintrc.json
jq '.extends += ["plugin:promise/recommended"]' .eslintrc.json > tmp && mv tmp .eslintrc.json
git add .
git commit -m 'add eslint plugins'

yarn add -D eslint-config-prettier
echo '{}' > .prettierrc
jq '.tabWidth = 2' .prettierrc > tmp && mv tmp .prettierrc
jq '.useTabs = false' .prettierrc > tmp && mv tmp .prettierrc
jq '.semi = false' .prettierrc > tmp && mv tmp .prettierrc
jq '.singleQuote = true' .prettierrc > tmp && mv tmp .prettierrc
jq '.extends += ["prettier"]' .eslintrc.json > tmp && mv tmp .eslintrc.json
git add .
git commit -m 'add prettier config'


yarn add -D eslint-config-airbnb-typescript
jq '.extends = ["airbnb-typescript/base"] + .extends' .eslintrc.json > tmp && mv tmp .eslintrc.json
jq '.rules = { "no-console": "off" }' .eslintrc.json > tmp && mv tmp .eslintrc.json
git add .
git commit -m 'add eslint airbnb config'

mkdir .vscode
cat > .vscode/extensions.json <<- EOF
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode"
  ]
}
EOF
git add .
git commit -m 'add recommended extensions'

cat > .vscode/launch.json <<- EOF
{
  "version": "0.2.0",
  "configurations": [
    {
      "runtimeExecutable": "\${workspaceFolder}/node_modules/.bin/ts-node",
      "type": "pwa-node",
      "request": "launch",
      "name": "Launch Server",
      "skipFiles": [
        "<node_internals>/**"
      ],
      "program": "\${workspaceFolder}/index.ts",
    }
  ]
}
EOF

echo "cd $DIRNAME"