# Hackathon Starter

## Synopsis
This tool generates an Express + TypeScript boilerplate and deploys it to an EC2 instance via GitHub Actions.

## Philosophy
This is an opinionated starter that aims to remove repetitive tasks required to ship a functional demo to the audience and the judges during a hackathon. 

Hackathon Starter only generates the backend. For the frontend, CRA + Netlify works well and is free.

## Included
- Yarn V1
- TypeScript
- Express
- ESLint
- CORS
- Logging
- VS Code settings
- CI/CD via GitHub Actions (SSH to an EC2 instance)
- HTTPS using Caddy

## Justifications
- TypeScript is used because it is the lingua franca of modern development and type checking helps engineers communicate.

- Yarn is used because it is the default package manager for another great hackathon boilerplate - CRA.

- EC2 is used because AWS has a great free tier.

## Not included, but easily added
- Database (prefer stateless, otherwise globals, SQLite or RDS)
- Authentication (don't productionize a functional demo)
- Payments (don't productionize a functional demo)
- Next.js (you don't need SSR for a functional demo)

## Usage
1. Create a GitHub repository
2. Create an AWS account
3. Spawn an EC2 instance (Amazon Linux t2.micro, 443 and 80 ports open)
4. 
    ```bash
    ./hackathonstarter username/reponame ~/Downloads/ec2sshkey.pem 3.3.3.3
    ```