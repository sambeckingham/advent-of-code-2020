import parseutils
import strformat
import strutils

var validCount: int
var validPosition: int

for line in lines("input.txt"):
    var lowerBound: int
    var upperBound: int
    var character: string
    var password: string
    
    var cursor = parseInt(line, lowerBound, 0)
    cursor += skip(line, "-", cursor)
    cursor += parseInt(line, upperBound, cursor)
    cursor += skipWhitespace(line, cursor)
    cursor += parseUntil(line, character, ":", cursor)
    cursor += skip(line, ":", cursor)
    cursor += skipWhitespace(line, cursor)
    password = line[cursor .. ^1]

    # Part 1
    var count = count(password, character)
    if count >= lowerbound and count <= upperBound: 
        validCount += 1

    # Part 2
    if password[lowerBound-1] == character[0] xor password[upperBound-1] == character[0]:
        validPosition += 1
    
echo &"Part 1: {validCount}"
echo &"Part 2: {validPosition}"