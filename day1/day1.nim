import strutils
import strformat

var entries = newSeq[int]()

for line in lines("input.txt"):
    entries.add(parseInt(line))

# Part 1
for idx1, _ in entries:
    for idx2, _ in entries:
        if idx1 == idx2:
            break

        if entries[idx1] + entries[idx2] == 2020:
            echo &"Part 1: {entries[idx1] * entries[idx2]}"
            break

# Part 2
# lol for loops go brrrrrrrrrr
for idx1, _ in entries:
    for idx2, _ in entries:
        if idx1 == idx2:
            break

        for idx3, _ in entries:
            if idx1 == idx3 or idx2 == idx3:
                break

            if entries[idx1] + entries[idx2] + entries[idx3] == 2020:
                echo &"Part 2: {entries[idx1] * entries[idx2] * entries[idx3]}"
                break