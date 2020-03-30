#!/bin/bash

#shellcheck source=/home/mendess/.local/bin/library
. library

update_creds () {
  echo "
  access_token=$access_token
  refresh_token=$refresh_token
  expires_at=$expires_at
  " > "$my_creds"
}

if [ -s "$LINKS"/yt ]
then
    # shellcheck source=/home/mendess/.local/share/links/yt
    . "$LINKS"/yt
fi

# Store our credentials in our home directory with a file called .
my_creds="$XDG_DATA_HOME"/ytaccess

# create your own client id/secret
# https://developers.google.com/identity/protocols/OAuth2InstalledApp#creatingcred

if [ -s "$my_creds" ]; then
  # if we already have a token stored, use it
  # shellcheck source=/home/mendess/.local/share/ytaccess
  . "$my_creds"
  time_now=$(date +%s)
else
  scope='https://www.googleapis.com/auth/youtube'
  # Form the request URL
  # https://developers.google.com/identity/protocols/OAuth2InstalledApp#step-2-send-a-request-to-googles-oauth-20-server
  auth_url="https://accounts.google.com/o/oauth2/v2/auth?client_id=$client_id&scope=$scope&response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob"

  echo "Please go to:"
  echo
  echo "$auth_url"
  echo
  echo "after accepting, enter the code you are given:"
  $BROWSER "$auth_url"
  read -r auth_code

  # exchange authorization code for access and refresh tokens
  # https://developers.google.com/identity/protocols/OAuth2InstalledApp#exchange-authorization-code
  auth_result=$(curl -s "https://www.googleapis.com/oauth2/v4/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d code="$auth_code" \
    -d client_id="$client_id" \
    -d client_secret="$client_secret" \
    -d redirect_uri=urn:ietf:wg:oauth:2.0:oob \
    -d grant_type=authorization_code)
  access_token=$(echo "$auth_result" | jq -r '.access_token')
  refresh_token=$(echo "$auth_result" | jq -r '.refresh_token')
  expires_in=$(echo "$auth_result" | jq -r '.expires_in')
  time_now=$(date +%s)
  expires_at=$((time_now + expires_in - 60))
  update_creds
fi

# if our access token is expired, use the refresh token to get a new one
# https://developers.google.com/identity/protocols/OAuth2InstalledApp#offline
if [ "$time_now" -gt "$expires_at" ]; then
  refresh_result=$(curl -s "https://www.googleapis.com/oauth2/v4/token" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   -d refresh_token="$refresh_token" \
   -d client_id=$client_id \
   -d client_secret=$client_secret \
   -d grant_type=refresh_token)
  access_token=$(echo "$refresh_result" | jq -r '.access_token')
  expires_in=$(echo "$refresh_result" | jq -r '.expires_in')
  time_now=$(date +%s)
  expires_at=$((time_now + expires_in - 60))
  update_creds
fi
export access_token
export API_TOKEN
