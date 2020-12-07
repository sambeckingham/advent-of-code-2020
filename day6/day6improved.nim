#[
So the original one was a mess because I cba'd making part 1 work for part 2.
With that said, using the Count table in Part 2 made me realise this was clearly the
best solution for both parts in Nim, so here it is done properly.
]#
import tables

var
  answerTable: CountTable[char]
  groupSize, uniqueAnswerTotal, allAnswerTotal: int

proc calculateGroup =
  for character, count in answerTable:
    inc uniqueAnswerTotal
    if count == groupSize:
      inc allAnswerTotal
  clear answerTable
  reset groupSize

block:
  defer: calculateGroup()
  for line in lines "input.txt":
    if line == "":
      calculateGroup()
    else:
      inc groupSize

    for character in line:
      answerTable.inc(character)

echo "Part 1: ", uniqueAnswerTotal
echo "Part 2: ", allAnswerTotal
