import strformat

var grid = newSeq[seq[bool]]()

for line in lines("input.txt"):
    var row = newSeq[bool]()
    for symbol in line:
        if symbol == '.': row.add(false) else: row.add(true)

    grid.add(row)

iterator traverseVertical(grid: seq[seq[bool]], y: int): seq[bool] =
    let maxY = grid.len - 1
    var currentY = 0
    while currentY < maxY:
        currentY += y
        yield grid[currentY]

iterator traverseSlope(grid: seq[seq[bool]], x: int, y: int): bool =
    let maxX = grid[0].len - 1
    var currentX = 0
    for row in traverseVertical(grid, y):
        currentX += x
        if currentX > maxX: currentX -= maxX+1
        yield row[currentX]

# Part 1
var totalTrees_3_1: int
for isTree in traverseSlope(grid, 3, 1):
    if isTree: inc totalTrees_3_1

# Part 2
var
    totalTrees_1_1: int
    totalTrees_5_1: int
    totalTrees_7_1: int
    totalTrees_1_2: int

for isTree in traverseSlope(grid, 1, 1):
    if isTree: inc totalTrees_1_1
for isTree in traverseSlope(grid, 5, 1):
    if isTree: inc totalTrees_5_1
for isTree in traverseSlope(grid, 7, 1):
    if isTree: inc totalTrees_7_1
for isTree in traverseSlope(grid, 1, 2):
    if isTree: inc totalTrees_1_2

echo &"Part 1: {totalTrees_3_1}"
echo &"Part 2: {totalTrees_1_1 * totalTrees_3_1 * totalTrees_5_1 * totalTrees_7_1 * totalTrees_1_2}"
