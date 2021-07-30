# Hackathon starter

## Synopsis
This tool will generate an Express + TypeScript boilerplate and deploy it to an EC2 instance via GitHub Actions.

## Philosophy
This boilerplate's goal is to remove repetetive tasks required to ship a functional demo to the judges and the audience during a hackathon. 

This boilerplate is opionated.

Hackathon starter only generates the backend. For the frontend, I'd recommend using CRA + Netlify.

## Included
- Yarn V1
- TypeScript
- Express
- ESLint
- CORS
- Logging
- VS Code settings
- CI/CD via GitHub Actions (SSH to an EC2 instance)

## Justifications
- TypeScript is used because it is the lingua franca of modern development and types help engineers to communicate.

- Yarn is used because it is the default package manager for another great hackathon boilerplate - CRA.

- EC2 is used because AWS has a great free tier.

## Not included, but easily added
- Database (prefer stateless, otherwise globals, SQLite or RDS)
- Authentication (don't productionize a functional demo)
- Payments (don't productionize a functional demo)
- Next.js (you don't need SSR for a functional demo)

## Usage
1. Create a GitHub repository
2. Create a AWS account
3. Spawn an EC2 instance (Amazon Linux t2.micro, 443 and 80 ports open)
4. 
    ```bash
    ./hackathonstarter username/reponame ~/Downloads/ec2sshkey.pem 3.3.3.3
    ```