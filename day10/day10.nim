import algorithm, sequtils, strutils, sugar, tables

var joltages = collect(newSeq):
  for line in lines "input":
    parseInt line

# Add broken port, device and sort ascending
add joltages, 0
add joltages, max(joltages) + 3
sort joltages

var differences = collect(newSeq):
  for i, joltage in joltages[1..^1]:
    joltage - joltages[i]

echo "Part 1: ", differences.count(1) * differences.count(3)

var optionsTable: Table[int, int]
optionsTable[0] = 1

for jolt in joltages[1 .. ^1]:
  optionsTable[jolt] = 0
  for ⚡ in 1..3:
    if optionsTable.contains(jolt-⚡):
      optionsTable[jolt] = optionsTable[jolt] + optionsTable[jolt-⚡]

echo "Part 2: ", optionsTable[max(joltages)]
