import strutils, sugar

let numbers = collect(newSeq):
    for line in lines "input":
        parseInt line

var preamble: seq[int]

var noSumNumber: int
for n in numbers:
    var nextNumber = n
    if preamble.len < 25:
        preamble.add(nextNumber)
        continue

    var sumFound: bool
    for number in preamble:
        if preamble.contains(nextNumber-number):
            sumFound = true
            break

    if not sumFound:
        noSumNumber = nextNumber
        break

    preamble = preamble[1 .. ^1]
    preamble.add(nextNumber)

echo "Part 1: ", noSumNumber

for i, n in numbers:
    var total = n
    for j, num in numbers[i+1 .. ^1]:
        inc total, num
        if total > noSumNumber:
            break
        elif total == noSumNumber and j > 0:
            var contiguousRange = numbers[i .. i+j+1]
            echo "Part 2: ", min(contiguousRange) + max(contiguousRange)
