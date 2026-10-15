#!/usr/bin/env python3
"""Writes the FSRS reference cases the Swift tests compare against.

The expected values come from py-fsrs, the reference implementation of FSRS:

    python3 -m venv .venv && .venv/bin/pip install fsrs==6.3.2
    .venv/bin/python scripts/generate-fsrs-fixtures.py

Output: Tests/EducationAITests/Fixtures/fsrs-reference.json. Each case is a scheduler
configuration and a sequence of reviews (rating, review time); after every review the file
records the card's state and the retrievability one day later. Fuzz is off, because py-fsrs
draws it from Python's own random generator. The cases are generated from a fixed seed, so
running the script again gives the same file.
"""

from __future__ import annotations

import json
import random
from datetime import datetime, timedelta, timezone
from importlib.metadata import version
from pathlib import Path

import fsrs
from fsrs import Card, Rating, Scheduler

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "Tests" / "EducationAITests" / "Fixtures" / "fsrs-reference.json"
START = datetime(2022, 11, 29, 12, 30, tzinfo=timezone.utc)
CASES_PER_CONFIGURATION = 25
REVIEWS_PER_CASE = 12

CONFIGURATIONS: list[dict] = [
    {"name": "defaults"},
    {"name": "retention 0.8", "desired_retention": 0.8},
    {"name": "retention 0.97", "desired_retention": 0.97},
    {"name": "no learning steps", "learning_steps": [], "relearning_steps": []},
    {"name": "one step each", "learning_steps": [600], "relearning_steps": [300]},
    {
        "name": "three steps",
        "learning_steps": [45, 300, 3600],
        "relearning_steps": [120, 900],
    },
    {"name": "maximum interval 30", "maximum_interval": 30},
    {
        "name": "trained weights",
        "parameters": [
            0.4072,
            1.1829,
            3.1262,
            15.4722,
            7.2102,
            0.5316,
            1.0651,
            0.0234,
            1.616,
            0.1544,
            1.0824,
            1.9813,
            0.0953,
            0.2975,
            2.2042,
            0.2407,
            2.9466,
            0.5034,
            0.6567,
            0.1,
            0.2,
        ],
    },
]


def make_scheduler(configuration: dict) -> Scheduler:
    return Scheduler(
        parameters=configuration.get("parameters", fsrs.scheduler.DEFAULT_PARAMETERS),
        desired_retention=configuration.get("desired_retention", 0.9),
        learning_steps=[
            timedelta(seconds=s) for s in configuration.get("learning_steps", [60, 600])
        ],
        relearning_steps=[
            timedelta(seconds=s) for s in configuration.get("relearning_steps", [600])
        ],
        maximum_interval=configuration.get("maximum_interval", 36500),
        enable_fuzzing=False,
    )


def next_review_time(rng: random.Random, card: Card) -> datetime:
    """On time, early, late, the same day, or long overdue, in whole seconds."""
    last = card.last_review or START
    gap = (card.due - last).total_seconds()
    kind = rng.random()
    if kind < 0.45:
        seconds = gap
    elif kind < 0.65:
        seconds = gap * rng.uniform(0.3, 0.95)
    elif kind < 0.85:
        seconds = gap * rng.uniform(1.05, 3.0) + rng.randint(0, 86400)
    elif kind < 0.95:
        seconds = rng.randint(30, 6 * 3600)
    else:
        seconds = gap + rng.randint(30, 400) * 86400
    return last + timedelta(seconds=max(1, round(seconds)))


def snapshot(scheduler: Scheduler, card: Card) -> dict:
    one_day_later = card.last_review + timedelta(days=1)
    return {
        "phase": {1: "learning", 2: "review", 3: "relearning"}[card.state.value],
        "step": card.step,
        "stability": card.stability,
        "difficulty": card.difficulty,
        "due": card.due.timestamp(),
        "lastReview": card.last_review.timestamp(),
        "retrievabilityOneDayLater": scheduler.get_card_retrievability(
            card, one_day_later
        ),
    }


def make_case(rng: random.Random, scheduler: Scheduler) -> dict:
    card = Card(due=START)
    reviews = []
    review_time = START
    for _ in range(REVIEWS_PER_CASE):
        rating = rng.choices(list(Rating), weights=[15, 15, 55, 15])[0]
        card, _ = scheduler.review_card(card, rating, review_time)
        reviews.append(
            {
                "rating": rating.value,
                "reviewedAt": review_time.timestamp(),
                "expected": snapshot(scheduler, card),
            }
        )
        review_time = next_review_time(rng, card)
    return {"reviews": reviews}


def main() -> None:
    rng = random.Random(20261015)
    configurations = []
    for configuration in CONFIGURATIONS:
        scheduler = make_scheduler(configuration)
        configurations.append(
            {
                "name": configuration["name"],
                "weights": list(scheduler.parameters),
                "desiredRetention": scheduler.desired_retention,
                "learningSteps": [
                    step.total_seconds() for step in scheduler.learning_steps
                ],
                "relearningSteps": [
                    step.total_seconds() for step in scheduler.relearning_steps
                ],
                "maximumInterval": scheduler.maximum_interval,
                "cases": [
                    make_case(rng, scheduler) for _ in range(CASES_PER_CONFIGURATION)
                ],
            }
        )
    document = {
        "generator": f"py-fsrs {version('fsrs')}",
        "configurations": configurations,
    }
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(document, separators=(",", ":")) + "\n")
    print(f"wrote {OUTPUT.relative_to(ROOT)}: {len(configurations)} configurations")


if __name__ == "__main__":
    main()
