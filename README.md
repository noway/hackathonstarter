# hackathon starter

## Synopsis
This tool will generate an Express + TypeScript boilerplate and deploy it to an EC2 instance via GitHub Actions.

## Included
- Yarn V1
- TypeScript
- Express
- ESlint
- CORS
- Logging
- VS Code settings
- CI/CD via GitHub Actions (ssh to an EC2 instance)

## Usage
1. Create new GitHub repository
2. Create new AWS account
3. Spawn an EC2 instance (Amazon Linux t2.micro, 443 and 80 ports open)
4. 
    ```bash
    ./hackathonstarter username/reponame ~/Downloads/ec2sshkey.pem 3.3.3.3
    ```