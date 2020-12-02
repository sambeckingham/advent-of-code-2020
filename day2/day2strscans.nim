#[
After my intial implementation I discovered the strscans module, which offers
a much cleaner syntax.  Interestingly however, the performance doesn't change.

Upon digging into the code it appears this is because `scanf` is just a macro
around the parseutils module!  That's some impressive compiler optimisation!
]#

import strscans
import strformat
import strutils

var validCount: int
var validPosition: int

for line in lines("input.txt"):
    var
        lowerBound: int
        upperBound: int
        character: string
        password: string
    
    # Part 1
    if scanf(line, "$i-$i $w: $w", lowerBound, upperBound, character, password):
        var count = count(password, character)
        if count >= lowerbound and count <= upperBound: 
            validCount += 1

    # Part 2
    if password[lowerBound-1] == character[0] xor password[upperBound-1] == character[0]:
        validPosition += 1
    
echo &"Part 1: {validCount}"
echo &"Part 2: {validPosition}"