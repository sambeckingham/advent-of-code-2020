import algorithm, sequtils, strutils, sugar, tables

var ⚡s = collect(newSeq):
  for line in lines "input":
    parseInt line

# Add broken port, device and sort ascending
add ⚡s, 0
add ⚡s, max(⚡s) + 3
sort ⚡s

var differences = collect(newSeq):
  for i, ⚡ in ⚡s[1..^1]:
    ⚡ - ⚡s[i]

echo "Part 1: ", differences.count(1) * differences.count(3)

var optionsTable: Table[int, int]
optionsTable[0] = 1

for ⚡ in ⚡s[1 .. ^1]:
  optionsTable[⚡] = 0
  for x in 1..3:
    if optionsTable.contains(⚡-x):
      optionsTable[⚡] = optionsTable[⚡] + optionsTable[⚡-x]

echo "Part 2: ", optionsTable[max(⚡s)]
