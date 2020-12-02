#[
This version features more concise syntax, whilst also skipping previously checked elements.

day1.nim:
    O(n) * O(n) * O(n) = O(n^3)
day1Improved.nim:
    O(n) * O(n-1) * O(n-2) = O(n^3 - 3n^2 + 2n)

Shaves off an average of 0.8ms in the input data.
]#

import strutils
import strformat

var entries = newSeq[int]()

for line in lines("input/day1.txt"):
    entries.add(parseInt(line))

# Part 1
for i, x in entries:
    for y in entries[i+1 .. ^1]:
        if x + y == 2020:
            echo &"Part 1: {x * y}"             

# Part 2
# lol for loops go brrrrrrrrrr
for i, x in entries:
    for j, y in entries[i+1 .. ^1]:
        for z in entries[i+j+1 .. ^1]:
            if x + y + z == 2020:
                echo &"Part 2: {x * y * z}"
                break