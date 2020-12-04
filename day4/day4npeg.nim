#[
Just discovered the coolest library ever, https://github.com/zevv/npeg, however the Day 4 code
from the author didn't give the correct answer.  I decided to reimplement to practice how this PEG library works.

Sidenote: Morepretty plays absolute havoc with this.
]#
import npeg, sequtils, strformat, strutils

var
  basicValidationTotal, basicDedupeValidationTotal, advancedValidationTotal,
    detailsPresent: int

#[
Part 1

We just want to ensure that the tokens exist.  There is sneaky gotcha with this implementation; It doesn't
dedupe fields. i.e., you could have 7 "byr" fields and that would appear to valid.
]#
let basicValidation = peg passports:
  passports <- +(passport | emptyline) # Passport input consists of two parts: the passport fields and the empty line delimiter
  passport  <- +(field * Space[1..2]): (if detailsPresent == 7: inc basicValidationTotal) # Match the fields and see if it's a valid passport...
  emptyline <- @"\c\n": detailsPresent = 0 # ... Or match the empty line and start a new Passport
  field     <- byr | iyr | eyr | hgt | hcl | ecl | pid | cid # Define the fields
  byr       <- "byr:" * +Graph: inc detailsPresent # These are all matching "key:<any amount of visible characters>"
  iyr       <- "iyr:" * +Graph: inc detailsPresent
  eyr       <- "eyr:" * +Graph: inc detailsPresent
  hgt       <- "hgt:" * +Graph: inc detailsPresent
  hcl       <- "hcl:" * +Graph: inc detailsPresent
  ecl       <- "ecl:" * +Graph: inc detailsPresent
  pid       <- "pid:" * +Graph: inc detailsPresent
  cid       <- "cid:" * +Graph #Lol no one cares

#[
Part 1b

I couldn't leave the dedupe gotcha in there, I had to figure out a way.  Et voila!
]#
var presentFields: seq[string]
let basicDedupeValidation = peg passports:
  passports <- +(passport | emptyline)
  passport  <- +(field * Space[1..2]): (if presentFields.deduplicate.len == 7: inc basicDedupeValidationTotal) 
  emptyline <- @"\c\n": presentFields = @[]
  field     <- byr | iyr | eyr | hgt | hcl | ecl | pid | cid # Define the fields
  byr       <- "byr:" * +Graph: presentFields.add("byr")
  iyr       <- "iyr:" * +Graph: presentFields.add("iyr")
  eyr       <- "eyr:" * +Graph: presentFields.add("eyr")
  hgt       <- "hgt:" * +Graph: presentFields.add("hgt")
  hcl       <- "hcl:" * +Graph: presentFields.add("hcl")
  ecl       <- "ecl:" * +Graph: presentFields.add("ecl")
  pid       <- "pid:" * +Graph: presentFields.add("pid")
  cid       <- "cid:" * +Graph #Lol still no one cares

#[
Part 2

Now it's a little trickier, we have to validate the values themselves instead of just their presence.
Luckily, npeg has a `>` character which captures values.  We can then run validation functions against it, check it out!

Sneaky gotcha: 
]#
var validFields: seq[string]
let advancedValidation = peg passports:
  passports <- +(passport | emptyline)
  passport  <- +(field * Space[1..2]): (if validFields.deduplicate.len == 7: inc advancedValidationTotal) 
  emptyline <- @"\c\n": validFields = @[]
  field     <- byr | iyr | eyr | hgt_cm | hgt_in | hcl | ecl | pid | cid
  byr       <- "byr:" * >+Digit: (if parseInt(capture[1].s) in 1920..2002: validFields.add("byr"))
  iyr       <- "iyr:" * >+Digit: (if capture[1].s.parseInt in 2010..2020: validFields.add("iyr"))
  eyr       <- "eyr:" * >+Digit: (if parseInt(capture[1].s) in 2020..2030: validFields.add("eyr"))
  hgt_cm    <- "hgt:" * >+Digit * "cm": (if parseInt(capture[1].s) in 150..193: validFields.add("hgt"))
  hgt_in    <- "hgt:" * >+Digit * "in": (if parseInt(capture[1].s) in 59..76: validFields.add("hgt"))
  hcl       <- "hcl:" * '#' * Xdigit[6]: validFields.add("hcl")
  ecl       <- "ecl:" * >Lower[3]: (if @["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(capture[1].s): validFields.add("ecl"))
  pid       <- "pid:" * Digit[9]: validFields.add("pid")
  cid       <- "cid:" * +Graph #sad-trombone.wav


var file = readFile("input.txt")

if basicValidation.match(file).ok:
  echo &"Part 1: {basicValidationTotal}"
if basicDedupeValidation.match(file).ok:
  echo &"Part 1b: {basicDedupeValidationTotal}"
if advancedValidation.match(file).ok:
  echo &"Part 2: {advancedValidationTotal}"
