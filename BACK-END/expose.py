import ssl
import urllib.request

# Disable SSL certificate verification (for testing purposes only)
ssl._create_default_https_context = ssl._create_unverified_context

from pyngrok import ngrok

# Now the ngrok call will also benefit if it needs to make HTTPS requests
public_url = ngrok.connect(8001)
print("Public URL:", public_url)
