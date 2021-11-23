#!/bin/bash 

API_TOKEN=""
PLAYER_TAG=""
URL="https://api.clashroyale.com/v1/players/${PLAYER_TAG}/upcomingchests"

curl -s -X GET --header 'Accept: application/json' \
     --header "authorization: Bearer ${API_TOKEN}" \
     $URL \
    | jq '.items[] | .name + ": " + (.index | tostring)'
    # | jq '.[] | map({(.name): .index}) | add'
