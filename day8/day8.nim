import sets, strscans

var instructions: seq[(string, int)]

for line in lines "input":
    var
        instruction: string
        amount: int
    if scanf(line, "$w $i", instruction, amount):
        add instructions, (instruction, amount)

block part1:
    var
        seenIndexes: HashSet[int]
        acc, i: int
    while true:
        var (instruction, amount) = instructions[i]
        case instruction:
            of "acc":
                inc acc, amount
                inc i
            of "nop":
                inc i
            of "jmp":
                inc i, amount

        i = i mod instructions.len
        if seenIndexes.containsOrIncl(i):
            break

    echo "Part 1: ", acc

block part2:
    var
        seenIndexes, flippedInstructions: HashSet[int]
        flipped: bool
        acc, i: int
    while true:
        var (instruction, amount) = instructions[i]
        case instruction:
            of "acc":
                inc acc, amount
                inc i
            of "nop":
                if not flippedInstructions.contains(i) and not flipped:
                    flippedInstructions.incl(i)
                    flipped = true
                    inc i, amount
                else:
                    inc i
            of "jmp":
                if not flippedInstructions.contains(i) and not flipped:
                    flippedInstructions.incl(i)
                    flipped = true
                    inc i
                else:
                    inc i, amount

        if i == instructions.len:
            break

        i = i mod instructions.len
        if seenIndexes.containsOrIncl(i):
            reset acc
            reset i
            reset flipped
            reset seenIndexes

    echo "Part 2: ", acc
