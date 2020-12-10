import algorithm, sequtils, strutils, sugar, tables

var ⚡s = collect(newSeq):
  for line in lines "input":
    parseInt line

# Add broken port, device and sort ascending
add ⚡s, 0
add ⚡s, max(⚡s) + 3
sort ⚡s

var differences = collect(newSeq):
  for i, ⚡ in ⚡s[1..^1]:
    ⚡ - ⚡s[i]

echo "Part 1: ", differences.count(1) * differences.count(3)

var optionsTable: Table[int, int]
optionsTable[0] = 1

for ⚡ in ⚡s[1 .. ^1]:
  optionsTable[⚡] = 0
  for x in 1..3:
    if optionsTable.contains(⚡-x):
      optionsTable[⚡] += optionsTable[⚡-x]

echo "Part 2: ", optionsTable[max(⚡s)]

#[
Say your input is:

1 2 3 6 8 9
Port: 0
Device: 12 (9 + 3)

You would have the following routes:
0 1 2 3 6 8 9 12
0 1 3 6 8 9 12
0 1 3 6 9 12

0 2 3 6 8 9 12
0 2 6 8 9 12
0 2 6 9 12

0 3 6 8 9 12
0 3 6 9 12

8 total combinations.

What we can do is calculate how many combinations there are to every single point
as we go along by memoising the total previous combinations.

So initially you're at 0, the port, and theres 1 way to get there (Hence optionsTable[0] = 1)
then at the next value, 1, we can see the table contains 1-1 (0), but not 1-2 or 1-3.  There is only 
one way to get to 1, so we can add that 1 to the total ways to reach the current position. Iterating, we see

 Input | Combos     | Total
  0    | 1 (0)      | 1
--------------------------------
  1    | 1 (0,1)    | 0 + 1 = 1
--------------------------------
  2    | 2 (1,2)    | 0 + 1
       |   (0,2)    |   + 1 = 2  <-- There are two ways to get to 2...
--------------------------------
  3    | 3 (2,3)    | 0 + 2      <-- ... We factor in these two ways here,
       |   (1,3)    |   + 1        - Plus the jump straight from 1 to 3,
       |   (0,3)    |   + 1 = 4    - And the jump straight from 0 to 3, so there are 4 combinations to get 3!
--------------------------------
  6    | 1 (3,6)    | 0 + 4 = 4
--------------------------------
  8    | 1 (6,8)    | 0 + 4 = 4
--------------------------------
  9    | 2 (6,9)    | 0 + 4
       |   (8,9)    |   + 4 = 8
--------------------------------
 12    | 1 (9,12)   | 0 + 8 = 8
]#