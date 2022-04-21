#!/usr/bin/env python3
#
# Roll for D20/D&D 5ed ability scores.
# Using procedure in Player's Handbook for D&D 5ed, p13.
# "Roll four 6-sided dice and record the total of the highest three"
#
import random

total = 0
for i in range(6):
    rolls = [random.randint(1,6) for _ in range(4)]
    score = sum(sorted(rolls)[1:])
    total += score
    print(f"{i+1}: Rolled {rolls}, ability score is {score}")

print(f"total {total}")
