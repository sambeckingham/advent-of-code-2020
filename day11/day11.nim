import sugar

type Seat = enum
  floor, empty, occupied

let layout = collect(newSeq):
  for line in lines "input":
    var row: seq[Seat]
    for c in line:
      case c:
      of 'L':
        row.add(empty)
      of '.':
        row.add(floor)
      of '#':
        row.add(occupied)
      else:
        echo "Unrecognised input character: ", c

    row

let CardinalDirections = @[
  (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)
]

proc iterateSeats(layout: seq[seq[Seat]]): seq[seq[Seat]] =
  var changes: int
  var newLayout: seq[seq[Seat]]
  for i, row in layout:
    var newRow: seq[Seat]
    for j, seat in row:
      var occupiedNeighbours: int

      for rowNum in -1 .. 1:
        if rowNum+i in low(layout)..high(layout):
          for colNum in -1 .. 1:
            if colnum+j in low(row)..high(row):
              if layout[i+rowNum][j+colNum] == occupied and not (rowNum == 0 and
                  colNum == 0):
                inc occupiedNeighbours

      if seat == empty and occupiedNeighbours == 0:
        newRow.add(occupied)
        inc changes
      elif seat == occupied and occupiedNeighbours >= 4:
        newRow.add(empty)
        inc changes
      else:
        newRow.add(seat)

    newLayout.add(newRow)

  if changes != 0:
    return iterateSeats(newLayout)
  return newLayout

proc iterateFarSeats(layout: seq[seq[Seat]]): seq[seq[Seat]] =
  var changes: int
  var newLayout: seq[seq[Seat]]
  for i, row in layout:
    var newRow: seq[Seat]
    for j, seat in row:
      var occupiedNeighbours: int

      for direction in CardinalDirections:
        var (x, y) = direction
        while true:
          if x+j in low(row)..high(row) and y+i in low(layout)..high(layout):
            case layout[y+i][x+j]
            of occupied:
              inc occupiedNeighbours
              break
            of empty:
              break
            else:
              discard
            y += direction[1]
            x += direction[0]
          else:
            break

      if seat == empty and occupiedNeighbours == 0:
        newRow.add(occupied)
        inc changes
      elif seat == occupied and occupiedNeighbours >= 5:
        newRow.add(empty)
        inc changes
      else:
        newRow.add(seat)

    newLayout.add(newRow)

  if changes != 0:
    return iterateFarSeats(newLayout)
  return newLayout

proc countSeats(layout: seq[seq[Seat]]): int =
  var count: int
  for row in layout:
    for seat in row:
      if seat == occupied:
        inc count
  count

echo "Part 1: ", countSeats iterateSeats(layout)

echo "Part 2: ", countSeats iterateFarSeats(layout)
