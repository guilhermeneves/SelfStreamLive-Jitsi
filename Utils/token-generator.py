import jwt

payload = {
  "context": {
    "user": {
      "avatar": "https://lh3.googleusercontent.com/proxy/4YqzyyhfsItZW4OJ77LNyxBii0FC1vO8_SM7jXZHo2aOvW2AdX7Ym95ErPbbJvbfs7bRZJuKrsTkc_p4zluZIDGCA9sZeTT66DaHDTgCPhg-4-q8aTq5GLhO8cYnQ00qTQijBQ",
      "name": "Guilherme Neves",
      "email": "guilherme.neves@selfstream.live",
      "id": "abcd:a1b2c3-d4e5f6-0abc1-23de-abcdef01fedcba"
    },
    "group": "a123-123-456-789"
  },
  "aud": "jitsi",
  "iss": "selfstreamlive",
  "sub": "test.selfstream.live",
  "room": "*",
  "exp": 1639267200,
  "moderator": False
}
secret = "ID-EVENTO-123456789test"
s = jwt.encode(payload, secret, algorithm="HS256")
print("token: ", s)