import time, hmac, hashlib

apiKey = "XXX"
apiSecret = b"XXX"
timestamp = str(int(time.time() * 1000))
method = "GET"
path = "/v2/account"
body = ""

pre_sign = timestamp + method + path + body
signature = hmac.new(apiSecret, pre_sign.encode("utf-8"), hashlib.sha256).hexdigest()

print("Timestamp:", timestamp)
print("Pre-sign string:", pre_sign)
print("Signature:", signature)
