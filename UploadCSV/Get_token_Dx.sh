#/bin/bash

APP_KEY=ключ приложения из п. 4

APP_SECRET=секретный ключ приложения из п. 4

ACCESS_CODE_GENERATED=код, полученный в п. 6

BASIC_AUTH=$(echo -n $APP_KEY:$APP_SECRET | base64)

echo ''
echo ''
echo ''

curl --location --request POST 'https://api.dropboxapi.com/oauth2/token' \
--header "Authorization: Basic $BASIC_AUTH" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "code=$ACCESS_CODE_GENERATED" \
--data-urlencode 'grant_type=authorization_code'
