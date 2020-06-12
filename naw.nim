import os, osproc, strutils, parseopt, streams, parsecsv, random, tables

if isMainModule:

  var header = """#? stdtmpl(emit="stdout.write &")"""
  
  const tmpn0 = "/tmp/nawprog$#.nim"
  var tmpn = ""
  for i in 0..100:
    tmpn = tmpn0 % $i
    if not fileExists(tmpn):
      break

  var separator = '\t'

  var p = initOptParser()
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      case p.key:
      of "h", "help":
        echo """Usage: naw -f programfile [datafile] ...
Usage: naw program

Options:
        -h/--help        Display usage
        -H               Explicitly set the header. Default: #? stdtmpl(emit="stdout.write &"
        -F               Set field separator character. Default: \t
        -f               Set program to execute
"""
        quit(0)
      of "H":
        header = p.val
      of "F":
        if len(p.val) == 0:
          raise newException(IOError, "If specifying separator -F, it must be one character" % p.val)
        if len(p.val) > 1:
          raise newException(IOError, "Separator $# must be one character only" % p.val)
        separator = p.val[0]
      of "f":
        var tmp = open(tmpn, fmWrite)
        tmp.writeLine(header)
        var src = open(p.key)
        for line in src.lines:
          tmp.writeLine(line)
        close(src)
        close(tmp)

    of cmdArgument:
      if not fileExists(tmpn):
        var tmp = open(tmpn, fmWrite)
        tmp.writeLine(header)
        tmp.write(p.key)
        close(tmp)

  if not fileExists(tmpn):
    raise newException(IOError, "Please provide a program file name with the -f switch, or program code as an argument")

  let r = execCmd("nim --import:strformat --import:strutils --import:naw --hints:off --warning[UnusedImport]:off -r c $# $#" % [tmpn, $ord(separator)])
  if r == 0:
    removeFile(tmpn)
  else:
    stderr.writeLine "Temporary nim program %s left in place due to compile error, please remove manually" % tmpn
  quit r

let separator = chr(parseInt(paramStr(1)))

template rows*(s: string): untyped =
  rows(openFileStream(s), s)

iterator rows*(f: Stream = newFileStream(stdin), n: string = "-", s:char = separator): CsvRow =
  var x: CsvParser
  open(x, f, n, s)
  while x.readRow():
    yield x.row
