# n8n + ngrok (Docker Setup)

This project runs **n8n** in Docker and exposes it securely using **ngrok**.  
It also supports **basic authentication** for securing your n8n instance.

---

## 1. Requirements

- Docker
- Docker Compose
- An [ngrok account](https://dashboard.ngrok.com/) and Auth Token

---

## 2. Clone Repo

```bash
git clone https://github.com/Kumarguptajit/Docker-wsl2-only-n8n-with-ngrok.git
cd docker-n8n-setup
```

## 3. Create a .env file in the project root:

```bash
# n8n settings
N8N_HOST=localhost
N8N_PORT=5678

# Basic Auth (used on login screen)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin@example.com
N8N_BASIC_AUTH_PASSWORD=SuperSecret123

# Ngrok settings
NGROK_AUTHTOKEN=your-ngrok-auth-token
NGROK_PORT=5678
```
