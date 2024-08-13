#!/usr/bin/env python3
"""Returns the list of school"""


def schools_by_topic(mongo_collection, topic):
    """returns the list of school having a specific topic """

    topic_filter = {
        "topics": {
            "$elementMatch": {
                "$equal": topic,
            },
        },
    }
    return [doc for doc in mongo_collection.find(topic_filter)]
