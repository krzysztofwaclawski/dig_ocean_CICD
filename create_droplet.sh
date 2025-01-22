#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create a new Droplet
DROPLET_ID=$(doctl compute droplet create build-server \
  --region nyc3 \
  --image ubuntu-20-04-x64 \
  --size s-1vcpu-1gb \
  --ssh-keys $SSH_KEY_ID \
  --user-data-file setup-script.sh \
  --format ID \
  --no-header)

# Assign the reserved IP to the new Droplet
doctl compute reserved-ip-action assign $RESERVED_IP --droplet-id $DROPLET_ID

echo "Droplet created and assigned reserved IP: $RESERVED_IP"