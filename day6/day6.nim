import sequtils, tables

# Part 1
var 
  characterSet: seq[char]
  total: int
for line in lines "input.txt":
  if line == "":
    inc(total, len deduplicate characterSet)
    characterSet = @[]
  
  for c in line:
    characterSet.add(c)

inc(total, len deduplicate characterSet)
characterSet = @[]

echo "Part 1: ", total

# Part 2
var 
  characterTable: CountTable[char]
  groupSize: int
  rotal: int
for line in lines "input.txt":
  if line == "":
    for _, count in characterTable.pairs:
      if count == groupSize:
        inc rotal
    clear characterTable
    groupSize = 0
  else:
    inc groupSize

  for c in line:
    characterTable.inc(c)

for _, count in characterTable.pairs:
  if count == groupSize:
    inc rotal
clear characterTable
groupSize = 0

echo "Part 2: ", rotal