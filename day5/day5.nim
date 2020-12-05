import sequtils

proc getRow(boardingPass: string): int =
  var rows = toSeq(0 .. 127)
  for c in boardingPass:
    case c:
      of 'B':
        rows = rows[rows.len div 2 .. ^1]
      of 'F':
        rows = rows[0 .. (rows.len - 1) div 2]
      else:
        echo "wat"
  rows[0]

doAssert getRow("FBFBBFF") == 44

proc getColumn(boardingPass: string): int =
  var columns = toSeq(0 .. 7)
  for c in boardingPass:
    case c:
      of 'R':
        columns = columns[(columns.len / 2) .. ^1]
      of 'L':
        columns = columns[0 .. (columns.len / 2)]
      else:
        echo "wat again"
  columns[0]

doAssert getColumn("RLR") == 5

proc getSeatID(boardingPass: string): int =
  let row = getRow(boardingPass[0..6])
  let column = getColumn(boardingPass[7..9])

  row * 8 + column

doAssert getSeatID("FBFBBFFRLR") == 357
doAssert getSeatID("BFFFBBFRRR") == 567
doAssert getSeatID("FFFBBBFRRR") == 119
doAssert getSeatID("BBFFBBFRLL") == 820

var seatIDs: seq[int]
for line in lines("input.txt"):
  seatIDs.add(getSeatID(line))

echo "Part 1: ", seatIds.max

var possibleSeats = 128*8
for i in 1 .. possibleSeats:
  if not seatIDs.contains(i):
    if seatIDs.contains(i-1) and seatIDs.contains(i+1):
      echo "Part 2: ", i
