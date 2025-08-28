#!/bin/sh
echo "Waiting for ngrok tunnel..."

# Wait until ngrok API returns a public URL
while true; do
  NGROK_URL=$(wget -qO- http://ngrok:4040/api/tunnels | grep -o '"public_url":"https[^"]*"' | sed 's/"public_url":"//;s/"//')
  if [ -n "$NGROK_URL" ]; then
    echo "----------------------------------------------------"
    echo "🚀 Ngrok public URL detected: $NGROK_URL"
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
