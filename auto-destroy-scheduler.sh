#!/bin/bash

# install jq
sudo apt-get -y install jq

# get droplet_id
droplet_id=$(curl -s http://169.254.169.254/metadata/v1/id)

# get subdomain_id
subdomain_id=$(echo $responseDomain | jq '.domain_record.id')

# Remove Subdomain associate with the droplet
curl --request DELETE \
  --url https://api.digitalocean.com/v2/domains/selfstream.live/records/${subdomain_id} \
  --header 'Authorization: Bearer 896ba0377c79ab6276fda8ffc423a66ded35480ab94be700fe2f53f05fb92db5' \
  --header 'Content-Type: application/json' \
  --cookie __cfduid=dd32467e27572b22a4c897e4c2e94906a1611618721

# Remove Droplet
curl --request DELETE \
  --url https://api.digitalocean.com/v2/droplets/${droplet_id} \
  --header 'Authorization: Bearer 896ba0377c79ab6276fda8ffc423a66ded35480ab94be700fe2f53f05fb92db5' \
  --header 'Content-Type: application/json' \
  --cookie __cfduid=dd32467e27572b22a4c897e4c2e94906a1611618721

