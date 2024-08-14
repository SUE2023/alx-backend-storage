#!/usr/bin/env python3
"""Get_page function """
import requests
import redis
from functools import wraps


# Initialize Redis client
redis_client = redis.Redis()


def cache_page(ttl: int):
    """Obtains the HTML content of a particular URL and returns it """
    def decorator(func):
        @wraps(func)
        def wrapper(url: str, *args, **kwargs):
            # Track URL access count
            count_key = f"count:{url}"
            redis_client.incr(count_key)

            # Try to get the cached content
            cache_key = f"cache:{url}"
            cached_content = redis_client.get(cache_key)

            if cached_content:
                return cached_content.decode('utf-8')

            # Fetch the page content from the URL
            html_content = func(url, *args, **kwargs)

            # Cache the result with an expiration time
            redis_client.setex(cache_key, ttl, html_content)
            
            return html_content
        return wrapper
    return decorator

@cache_page(ttl=10)
def get_page(url: str) -> str:
    response = requests.get(url)
    return response.text
