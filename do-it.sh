    curl -v -XPOST --http1.1 \
      https://api.twitter.com/1.1/statuses/update.json \
      -d "status=Hello" \
      -H 'Authorization: OAuth oauth_consumer_key="CWBfHjubBF6n01UDQXHE7oFCW", oauth_nonce="d7c59ef25dbbdb1c12eba4f1f3a4b46e7a257f3917970839e2359c8dd0280b07", oauth_signature="V3rA0YXsShBxteGkkqTmDvDilg8%3D%0A", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1567992472", oauth_token="150569754-ZwUPzvysy17MeKtZttIyoe9uSyj59xuKoT3TodFr", oauth_version="1.0"'
