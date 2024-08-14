#!/usr/bin/env python3
"""Get_page function """
import requests
import redis
import time


# Initialize Redis client
redis_client = redis.Redis()


def get_page(url: str) -> str:
    """Track URL access count"""
    count_key = f"count:{url}"
    redis_client.incr(count_key)
    
    # Try to get the cached content
    cache_key = f"cache:{url}"
    cached_content = redis_client.get(cache_key)
    
    if cached_content:
        return cached_content.decode('utf-8')

    # Fetch the page content from the URL
    response = requests.get(url)
    html_content = response.text

    # Cache the result with an expiration time of 10 seconds
    redis_client.setex(cache_key, 10, html_content)
    
    return html_content
