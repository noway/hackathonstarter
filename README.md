# Hackathon Starter
Generate an Express + TypeScript project and deploy it to an EC2 instance via GitHub Actions.

## Usage
```bash
./hackathonstarter <user/repo> <key> <ec2ip>
```

## Instruction
1. Create a GitHub repository
2. Create an AWS account
3. Spawn an EC2 instance (Amazon Linux t2.micro, 443 and 80 ports open)
4. 
    ```bash
    ./hackathonstarter noway/coolhackapi ~/Downloads/coolhack2021.pem 3.25.152.175
    ```

## Example output
```
...
[PM2] Spawning PM2 daemon with pm2_home=/home/ec2-user/.pm2
[PM2] PM2 Successfully daemonized
[PM2] Starting /bin/yarn in fork_mode (1 instance)
[PM2] Done.
┌─────┬──────────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
│ id  │ name         │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
├─────┼──────────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
│ 0   │ coolhackapi  │ default     │ N/A     │ fork    │ 3623     │ 0s     │ 0    │ online    │ 0%       │ 2.7mb    │ ec2-user │ disabled │
└─────┴──────────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
https://ec2-3-25-152-175.ap-southeast-2.compute.amazonaws.com
https://github.com/noway/coolhackapi
+ echo https://ec2-3-25-152-175.ap-southeast-2.compute.amazonaws.com
+ echo https://github.com/noway/coolhackapi
```

## Example repo
https://github.com/noway/thisprimedoesnotexist

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

## System requirements
Make sure following are installed on your system: `npx`, `yarn`, `git` and `jq`.
