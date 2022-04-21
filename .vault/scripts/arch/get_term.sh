#! /usr/bin/python

from datetime import date
wodo = 3
thisWeek = date.today().isocalendar()[1] - 1
toDay = date.today().strftime('%j')

# the first week # of each term
firstWeek = {
  "T1": 1,
  "T2": 11,
  "T3": 25,
  "T4": 36,
}

def printWeek(thisWeek, term):
  termStart = firstWeek[term]
  if thisWeek in range(termStart, termStart+10):
    print(term, " W", thisWeek - termStart + 1, sep='')

printWeek(thisWeek, "T1")
printWeek(thisWeek, "T2")
printWeek(thisWeek, "T3")
printWeek(thisWeek, "T4")
