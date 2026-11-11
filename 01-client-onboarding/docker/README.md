# Docker setup

Runs NocoDB (the tables) and Mailpit (a fake mail server that catches every email). n8n runs separately and joins the same Docker network.

1. Copy .env.example to .env and set NC_AUTH_JWT_SECRET (for example with: openssl rand -hex 32). Never commit .env.
2. Run: docker compose up -d
3. NocoDB is at http://localhost:8081 and the Mailpit inbox at http://localhost:8025.
4. Inside the Docker network, n8n reaches them as http://nocodb:8080 and mailpit:1025.

The compose file expects an existing Docker network named n8n-sandbox. Create it with: docker network create n8n-sandbox
