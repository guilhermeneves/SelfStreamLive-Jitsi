import jwt

payload = {
  "context": {
    "user": {
      "avatar": "https:/gravatar.com/avatar/abc123",
      "name": "John Doe",
      "email": "jdoe@example.com",
      "id": "abcd:a1b2c3-d4e5f6-0abc1-23de-abcdef01fedcba"
    },
    "group": "a123-123-456-789"
  },
  "aud": "jitsi",
  "iss": "selfstreamlive",
  "sub": "meuevento-hosts.selfstream.live",
  "room": "*",
  "exp": 1639267200,
  "moderator": True
}
secret = "ID-EVENTO-123456789meuevento-hosts"
s = jwt.encode(payload, secret, algorithm="HS256")
print("token: ", s)