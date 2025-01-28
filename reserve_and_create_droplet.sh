#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Reserve a new IP in the Frankfurt region were issues with jq need to simplify that grep
RESERVED_IP=$(doctl compute reserved-ip create fra1 --output json | grep -oP '(?<="ip":")[^"]*')

# Create a new Droplet in the Frankfurt region
DROPLET_ID=$(doctl compute droplet create build-server \
  --region fra1 \
  --image ubuntu-20-04-x64 \
  --size s-1vcpu-1gb \
  --ssh-keys $SSH_KEY_ID \
  --user-data-file setup-script.sh \
  --output json | grep -oP '(?<="id":)[0-9]+')

# Assign the reserved IP to the new Droplets
doctl compute reserved-ip-action assign $RESERVED_IP --droplet-id $DROPLET_ID

echo "Droplet created and assigned reserved IP: $RESERVED_IP"

# Save the reserved IP to a file for later use
echo $RESERVED_IP > reserved_ip.txt