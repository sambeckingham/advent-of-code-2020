#[
Decided to write procs with some unit tests for this one. Serializing the text into a passport object was a bit ghetto,
wondering if there's a more succint way of writing it.
]#

import strformat, strscans, strutils
type
  Passport = object
    ecl: string
    pid: string
    eyr: string
    hcl: string
    byr: string
    iyr: string
    cid: string
    hgt: string

proc eyeColourIsValid*(ecl: string): bool =
  ecl in @["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

doAssert eyeColourIsValid("") == false
doAssert eyeColourIsValid("bum") == false
doAssert eyeColourIsValid("amb") == true

proc birthYearIsValid(byr: string): bool =
  try:
    byr.parseInt() in 1920 .. 2002
  except ValueError:
    false

doAssert birthYearIsValid("") == false
doAssert birthYearIsValid("1919") == false
doAssert birthYearIsValid("1920") == true
doAssert birthYearIsValid("2002") == true
doAssert birthYearIsValid("2003") == false

proc issueYearIsValid(iyr: string): bool =
  try:
    iyr.parseInt() in 2010 .. 2020
  except ValueError:
    false

doAssert issueYearIsValid("") == false
doAssert issueYearIsValid("2009") == false
doAssert issueYearIsValid("2010") == true
doAssert issueYearIsValid("2020") == true
doAssert issueYearIsValid("2021") == false

proc expirationYearIsValid(eyr: string): bool =
  try:
    eyr.parseInt() in 2020 .. 2030
  except ValueError:
    false

doAssert expirationYearIsValid("") == false
doAssert expirationYearIsValid("2019") == false
doAssert expirationYearIsValid("2020") == true
doAssert expirationYearIsValid("2030") == true
doAssert expirationYearIsValid("2031") == false

proc heightIsValid(hgt: string): bool =
  var height: int
  if scanf(hgt, "$icm", height):
    return height in 150 .. 193
  elif scanf(hgt, "$iin", height):
    return height in 59 .. 76

  false

doAssert heightIsValid("") == false
doAssert heightIsValid("149cm") == false
doAssert heightIsValid("150cm") == true
doAssert heightIsValid("193cm") == true
doAssert heightIsValid("194cm") == false
doAssert heightIsValid("58in") == false
doAssert heightIsValid("59in") == true
doAssert heightIsValid("76in") == true
doAssert heightIsValid("77in") == false

proc hairColourIsValid(hcl: string): bool =
  if not hcl.startsWith('#'): return false
  if hcl.len != 7: return false
  for c in hcl[1..6]:
    if c notin {'0'..'9', 'a'..'f', 'A'..'F'}: return false
  return true

doAssert hairColourIsValid("") == false
doAssert hairColourIsValid("09afAF") == false
doAssert hairColourIsValid("#09afAF") == true
doAssert hairColourIsValid("#09afAG") == false
doAssert hairColourIsValid("#09afA") == false
doAssert hairColourIsValid("#09afAFA") == false

proc passportIDIsValid(pid: string): bool =
  if pid.len != 9: return false
  for digit in pid:
    if digit notin '0'..'9': return false
  return true

doAssert passportIDIsValid("") == false
doAssert passportIDIsValid("123456789") == true
doAssert passportIDIsValid("000000000") == true
doAssert passportIDIsValid("12345678") == false
doAssert passportIDIsValid("1234567890") == false

var
  passports: seq[Passport]
  currentPassport: Passport

for line in lines "input.txt":
  if line == "":
    passports.add currentPassport
    currentPassport = Passport()
    continue

  var details = line.splitWhitespace()
  for detail in details:
    var
      key: string
      value: string
    if scanf(detail, "$w:$*", key, value):
      case key:
        of "ecl":
          currentPassport.ecl = value
        of "pid":
          currentPassport.pid = value
        of "eyr":
          currentPassport.eyr = value
        of "hcl":
          currentPassport.hcl = value
        of "byr":
          currentPassport.byr = value
        of "iyr":
          currentPassport.iyr = value
        of "cid":
          currentPassport.cid = value
        of "hgt":
          currentPassport.hgt = value

passports.add(currentPassport)

var
  totalValidPart1: int
  totalValidPart2: int

# Part 1
for passport in passports:
  if
    passport.ecl != "" and
    passport.pid != "" and
    passport.eyr != "" and
    passport.hcl != "" and
    passport.byr != "" and
    passport.iyr != "" and
    passport.hgt != "":
      inc totalValidPart1

# Part 2
for passport in passports:
  if
    eyeColourIsValid(passport.ecl) and
    passportIDIsValid(passport.pid) and
    expirationYearIsValid(passport.eyr) and
    hairColourIsValid(passport.hcl) and
    birthYearIsValid(passport.byr) and
    issueYearIsValid(passport.iyr) and
    heightIsValid(passport.hgt):
      inc totalValidPart2

echo &"Part 1: {totalValidPart1}"
echo &"Part 2: {totalValidPart2}"
