# n8n + ngrok (Docker Setup with no windows only wsl2)

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


## 4. Docker Compose File

Create docker-compose.yaml:

```bash
services:
  n8n:
    image: n8nio/n8n
    restart: unless-stopped
    ports:
      - "443:5678"  # HTTPS access
    environment:
      - N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE}
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - DB_SQLITE_POOL_SIZE=1
      - N8N_RUNNERS_ENABLED=true
    volumes:
      - ~/.n8n:/home/node/.n8n
      - ./wait-for-ngrok.sh:/app/wait-for-ngrok.sh
    depends_on:
      - ngrok
    entrypoint: ["/bin/sh", "-c", "/app/wait-for-ngrok.sh && n8n start"]

  ngrok:
    image: ngrok/ngrok:latest
    command: http n8n:5678 --log=stdout
    environment:
      - NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}
```


## 5. Script to Wait for ngrok

Create wait-for-ngrok.sh:

```bash
#!/bin/sh
echo "Waiting for ngrok tunnel..."

# Wait until ngrok API returns a public URL
while true; do
  NGROK_URL=$(wget -qO- http://ngrok:4040/api/tunnels | grep -o '"public_url":"https[^"]*"' | sed 's/"public_url":"//;s/"//')
  if [ -n "$NGROK_URL" ]; then
    echo "----------------------------------------------------"
    echo "Ngrok public URL detected: $NGROK_URL"
    echo "Use this URL for your n8n workflows/webhooks"
    echo "----------------------------------------------------"

    # Export so n8n knows the webhook URL
    export N8N_WEBHOOK_URL=$NGROK_URL

    # Background loop to print URL every 10 seconds
    while true; do
      echo "Ngrok URL: $NGROK_URL"
      sleep 10
    done &

    break
  fi
  sleep 1
done
```

Make it executable:

```bash
chmod +x wait-for-ngrok.sh
```

## 6. Start the servcies

```bash
docker-compose down
docker-compose up -d
```

Check logs and copy the url paste in browser to open n8n workflow:

```bash
docker-compose logs -f ngrok
```
