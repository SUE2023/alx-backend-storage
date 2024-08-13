#!/usr/bin/env python3
"""Students Sorting by Average"""


def top_students(mongo_collection):
    """Prints students in a collection sorted by average score."""
    students = mongo_collection.aggregate(
        [{"$project": {
                    "_id": 1,
                    "name": 1,
                    "averageScore": {
                        "$avg": {
                            "$avg": "$topics.score",
                        },
                    },
                    "topics": 1,
                },
            },
            {"$sort": {"averageScore": -1},
            },
        ]
    )
    return students
