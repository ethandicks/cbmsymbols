# cbmsymbol

There have been lists and lists of common ROM entry points and zero page locations for Commodore 8-bit computers going back to the first major PET ROM revision in 1979.  These lists were first published in newsletters then books then much, much later, on the Web.  In order to complete a different project of mine, I needed a fairly extensive list of BASIC and Kernal entry points spanning original PET BASIC through at least the Commodore 64. To build the list I needed, it seemed most expedient to use the listing files from the cbmsrc project.

Provided here is a Perl script to slurp up these listing files and extract all the symbols, and emit them in formatted columns of numbers that are easy to grep and could easily be imported into spreadsheets or tables in any markdown language.  Also provided are a couple of examples of the output that I have found to be useful.

The input data is any listing file produced by cbm6502asm.  The important formatting is that symbols are emitted on lines beginning with a space, and any line that doesn't start with a space will be discarded here.  A line of acceptable symbols looks like this:
```
SYMBOL VALUE
 ABS      DB64    ADDEND   0025    ADDFRS   C2D0    ADDIND   D1FC
 ADDON    C803    ADDPR2   0002    ADDPR4   0004    ADDPR8   0008
 ADDPRC   0001    AFFRTS   C550    ANDMSK   0046    ANDOP    CECB
```

Symbols are expected to be in upper case, interleaved with the values, as upper case hex with no numeric base markers.  Other symbol table formats could be added with minimal effort.

The present script emits symbolic labels and values grabbed from each of the input files but does not, at this time, have a text field to document the purpose of the label (TODO)
