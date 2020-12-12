import re, strutils

type CardinalDirections {.pure.} = enum
  North, East, South, West

type Directions {.pure.} = enum 
  Right, Left

proc isEven(x: int): bool =
  x mod 2 == 0

doAssert isEven(2) == true
doAssert isEven(1) == false

proc rotate(start: CardinalDirections, direction: Directions, degrees: int): CardinalDirections =
  let
    directions = @[North, East, South, West]
    currentDirectionIndex = directions.find(start)
  var
    quarterTurns = (degrees div 90) mod 4
    newDirectionIndex: int

  if direction == Left and not isEven quarterTurns:
    quarterTurns = (quarterTurns + 2) mod 4

  newDirectionIndex = (currentDirectionIndex + quarterTurns) mod 4
  
  directions[newDirectionIndex]

doAssert CardinalDirections.North.rotate(Right, 90) == East
doAssert CardinalDirections.North.rotate(Right, 180) == South
doAssert CardinalDirections.North.rotate(Right, 270) == West
doAssert CardinalDirections.North.rotate(Right, 360) == North
doAssert CardinalDirections.North.rotate(Left, 90) == West
doAssert CardinalDirections.North.rotate(Left, 180) == South
doAssert CardinalDirections.North.rotate(Left, 270) == East
doAssert CardinalDirections.North.rotate(Left, 360) == North

proc rotateWaypoint(waypointCoords: (int, int), direction: Directions, degrees: int): (int, int) =
  var
    waypointCoords = waypointCoords
    quarterTurns = (degrees div 90) mod 4

  if direction == Left and not isEven quarterTurns:
    quarterTurns = (quarterTurns + 2) mod 4

  if quarterTurns == 0:
    return waypointCoords

  for _ in countup(1, quarterTurns):
    waypointCoords = (waypointCoords[1], -waypointCoords[0])
  
  return waypointCoords

doAssert (10, 4).rotateWaypoint(Right, 90) == (4, -10)
doAssert (10, 4).rotateWaypoint(Right, 180) == (-10, -4)
doAssert (10, 4).rotateWaypoint(Right, 270) == (-4, 10)
doAssert (10, 4).rotateWaypoint(Right, 360) == (10, 4)
doAssert (10, 4).rotateWaypoint(Left, 90) == (-4, 10)
doAssert (10, 4).rotateWaypoint(Left, 180) == (-10, -4)
doAssert (10, 4).rotateWaypoint(Left, 270) == (4, -10)
doAssert (10, 4).rotateWaypoint(Left, 360) == (10, 4)

var
  totalX, totalY: int
  currentDirection = East

for line in lines "input":
  var captures: array[2, string]
  if match(line, re"(N|E|S|W|L|R|F)(\d+)", captures):
    let
      command = captures[0]
      magnitude = parseInt captures[1]

    case command
    of "N":
      inc totalY, magnitude
    of "E":
      inc totalX, magnitude
    of "S":
      dec totalY, magnitude
    of "W":
      dec totalX, magnitude 
    of "L":
      currentDirection = currentDirection.rotate(Left, magnitude)
    of "R":
      currentDirection = currentDirection.rotate(Right, magnitude)
    of "F":
      case currentDirection:
      of North:
        inc totalY, magnitude
      of East:
        inc totalX, magnitude
      of South:
        dec totalY, magnitude
      of West:
        dec totalX, magnitude 

echo "Part 1: ", abs(totalX) + abs(totalY)
  
var
  waypointCoords = (10, 1)
  shipCoords = (0, 0)

for line in lines "input":
  var captures: array[2, string]
  if match(line, re"(N|E|S|W|L|R|F)(\d+)", captures):
    let
      command = captures[0]
      magnitude = parseInt captures[1]

    case command
    of "N":
      inc wayPointCoords[1], magnitude 
    of "E":
      inc wayPointCoords[0], magnitude
    of "S":
      dec waypointCoords[1], magnitude
    of "W":
      dec wayPointCoords[0], magnitude
    of "L":
      waypointCoords = waypointCoords.rotateWaypoint(Left, magnitude)
    of "R":
      waypointCoords = waypointCoords.rotateWaypoint(Right, magnitude)
    of "F":
      inc shipCoords[0], waypointCoords[0] * magnitude
      inc shipCoords[1], waypointCoords[1] * magnitude

echo "Part 2: ", abs(shipCoords[0]) + abs(shipCoords[1])