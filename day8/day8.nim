import sets, strscans

var instructionSet: seq[(string, int)]

for line in lines "input":
    var
        instruction: string
        amount: int
    if scanf(line, "$w $i", instruction, amount):
        add instructionSet, (instruction, amount)

block part1:
    var
        seenIndexes: HashSet[int]
        infiniteLoopDetected = false
        acc, i: int
    while not infiniteLoopDetected:
        var (instruction, amount) = instructionSet[i]
        case instruction:
            of "acc":
                inc acc, amount
                inc i
            of "nop":
                inc i
            of "jmp":
                inc i, amount

        i = i mod instructionSet.len
        if seenIndexes.containsOrIncl(i):
            infiniteLoopDetected = true

    echo "Part 1: ", acc

block part2:
    var
        seenIndexes, flippedInstructions: HashSet[int]
        corruptBitFound, flipped: bool
        acc, i: int
    while not corruptBitFound:
        var (instruction, amount) = instructionSet[i]
        case instruction:
            of "acc":
                inc acc, amount
                inc i
            of "nop":
                if not flippedInstructions.contains(i) and not flipped:
                    flippedInstructions.incl(i)
                    inc i, amount
                    flipped = true
                else:
                    inc i
            of "jmp":
                if not flippedInstructions.contains(i) and not flipped:
                    flippedInstructions.incl(i)
                    inc i
                    flipped = true
                else:
                    inc i, amount

        if i == instructionSet.len:
            corruptBitFound = true

        i = i mod instructionSet.len
        if seenIndexes.containsOrIncl(i):
            reset acc
            reset i
            reset flipped
            reset seenIndexes

    echo "Part 2: ", acc
