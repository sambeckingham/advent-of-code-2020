import sequtils, strutils, sugar

let input = open("input")
let departureTime = parseInt readLine(input)
let services = readLine(input).split(',')
close input

# Part 1
var earliestService, shortestWait: int

for time in services.filter(s => s != "x").map(s => parseInt s):
  var wait = time - (departureTime mod time)
  if wait < shortestWait or shortestWait == 0:
    shortestWait = wait
    earliestService = time

echo "Part 1: ", earliestService * shortestWait

# Part 2
let
  normalisedServices = services
    .map(s => s.replace("x", "1"))
    .map(s => parseInt s)
var totalInterval = 1
reset earliestService

for i, service in normalisedServices:
  while (earliestService+i) mod service != 0:
    inc earliestService, totalInterval

  totalInterval *= service

echo "Part 2: ", earliestService
