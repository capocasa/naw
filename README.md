Naw
===

Naw is a small glue wrapper around nim to do awk-style text processing with it.

Installation
------------

    nimble install naw

Usage
-----

Launch it with `naw '...nim code...' ` inputting data to stdin. The following example generates a markdown table from CSV.

    echo 'foo,1
    bar,2
    fuz,3
    buz,4' | naw -F, 'My Report
    ===========

    {"":-<20} {"":-<20}
    # for r in rows():
    {r[0]:<20} {r[1]:>20}
    # end
    {"":-<20} {"":-<20}
    # for r in rows():
    {r[0]} {r[1]}
    # end
    '

yields

    My Report  
    ===========

    -------------------- --------------------
    foo                                     1
    bar                                     2
    fuz                                     3
    buz                                     4
    -------------------- --------------------


Features
--------

Complete Nim syntax is supported through the `stdtmpl` source code filter. Complete nim strformat syntax is supported for output.

Additional convenience syntax is added:

------------------------- --------------------------------------------------------------------------
`rows()`                  Iterator to iterate through a CSV stdin, using the seperator
`rows("filename")`        specified with -F

`+`                       Unary plus-sign, synonymous for parseInt
`~`                       Unary tilde, synonymous for parseFloat
------------------------- --------------------------------------------------------------------------

Requirements
------------

naw requires the Nim compiler to work.


Internals
---------

naw bolts strformat onto the stdtmpl language and adds some glue, resulting in a really concise
templating language for text formatting form CSV data, which is exactly what awk's domain is.

If you don't mind creating a file to compile, you can get very similar results to naw with pure nim

    #? stdtmpl(emit="stdout.write &")
    # import strformat, streams, parsecsv
    # var x: CsvParser
    # open(x, newFileStream(stdin), "-", '\t')

    My Report
    =========

    {"":-<20} {"":-<20}
    # while x.readRow():
    {x.row[0]:<20} {x.row[1]:>20}
    # end
    {"":-<20} {"":-<20}

naw just allows you to pass the code as a command line parameter, which is nice if you're familiar with awk,
and auto-imports strformat, streams and parsecsv as well as adding some shorthand syntax of its own.

Limitations
-----------

Naw is experimental but small enough to work reasonably well off the bat. Install a specific version for to avoid changes.

      nimble install naw@0.1.0

License
-------

naw is MIT-Licensed
