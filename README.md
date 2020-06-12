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


`rows()` iterates through all rows of stdin.

`rows("path/to/my/file")` iterates through the rows of arbitrary files. They can be combined.

These are canonical and most convenient use cases, but arbitary code may be used to aquire or generate data.

Features
--------

Complete Nim syntax is supported through the `stdtmpl` source code filter. Complete nim strformat syntax is supported for output.

Requirements
------------

naw requires the Nim compiler to work.

Limitations
-----------

Naw is experimental but small enough to work reasonably well off the bat. Install a specific version for to avoid changes.

      nimble install naw@0.1.0

License
-------

naw is MIT-Licensed
