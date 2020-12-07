import npeg, sequtils, strutils, tables

# Parse bag input

var
    bagTable: Table[string, CountTable[string]]
    parent: string
    children: CountTable[string]
let bagParser = peg bags:
    bags <- parentBag * " contain " * +childBag
    parentBag <- >colour * Space * "bags":
        parent = $1
    childBag <- >count * Space * >colour * Space * ("bags" | "bag") * (", " | "."):
        children.inc($2, parseInt($1))
    colour <- +Alpha * Space * +Alpha
    count <- +Digit

for line in lines "input":
    reset children
    var _ = bagParser.match(line)
    bagTable[parent] = children

# Part 1

proc findParentBags(bags: seq[string], acc: seq[string]): seq[string] =
    var
        acc = deduplicate acc
        nextIteration: seq[string]
    for bag in bags:
        for parent, children in bagTable:
            if children.contains(bag):
                nextIteration.add(parent)

    nextIteration = deduplicate nextIteration

    if nextIteration.len == 0:
        return acc

    findParentBags(nextIteration, acc & nextIteration)

echo "Part 1: ", len findParentBags(@["shiny gold"], newSeq[string]())

# Part 2

proc getTotalChildren(bag: string, multi: int = 1, acc: int = 0): int =
    var acc = acc
    for child, count in bagTable[bag]:
        inc acc, count * multi
        acc = getTotalChildren(child, count * multi, acc)

    return acc

echo "Part 2: ", getTotalChildren("shiny gold")
