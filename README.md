# cbmsymbols

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

## Usage:

```./mkmmap HDR1,file1.txt HDR2,file2.txt [COMMENT,symbols.csv]...```

## Detailed example:

Combine the BASIC and KERNAL (and EDIT ROM) listings for three versions of PETs (it is not required to remove the listing lines)

```
$ cat BASIC_PET_V1_REC.lst KERNAL_PET_1.0_REC.lst >PET1.txt
$ cat BASIC_PET_V2_REC.lst KERNAL_PET_2.0_REC.lst >PET2.txt
$ cat BASIC_PET_V4_REC.lst KERNAL_PET_4.0_REC.lst >PET4.txt
```

Then to produce a memory map of all three versions and to sort the symbols in preference of BASIC 4.0, then Original BASIC, then Upgrade BASIC:

```
./mkmmap 1.0,PET1.txt 2.0,PET2.txt 4.0,PET4.txt | (sed -u 1q; sort -k4,4 -k2,2 -k3,3)
```

(the sed command pulls out the header line prior to sorting)

The resulting output is:

```
LABEL     1.0     2.0     4.0     
MRCHR      ----   $D75A    ----
PKINC      ----   $D766    ----
LE082      ----   $E082    ----
.
.
.
ERRNF     $0000   $0000   $0000
USRPOK    $0000   $0000   $0000
BLF       $0001   $0001   $0001
ADDPRC    $0001   $0001   $0001
BUFPAG     ----   $0002   $0002
.
.
.
ISCNTC    $FFE1   $FFE1   $FFE1
CGETL     $FFE4   $FFE4   $FFE4
CCALL     $FFE7   $FFE7   $FFE7
```

## Additional example:

Expanding on the original example, to add VIC-20 and Commodore 64 symbols and a comments field, start by generating the additional listing files.  There are three major versions of C64 KERNAL ROMs so the entire range is:

```
$ cat BASIC_VIC.lst KERNAL_VIC_04.lst >VIC20.lst
$ cat BASIC_C64.lst KERNAL_C64_01.lst >C64-01.txt
$ cat BASIC_C64.lst KERNAL_C64_02.lst >C64-02.txt
$ cat BASIC_C64.lst KERNAL_C64_03.lst >C64-03.txt
```

On top of the extra two address columns, one can find or generate a CSV file with a label and a comment.  Because existing comments files are not well formed, mkmmap splits the comments CSV on the first comma only and does not require the text field to be wrapped in quotes, even if it contains commas.  Symbols are usually in upper-case, except when a symbol could be defined twice (as when a BASIC listing is joined to a KERNAL listing) where the second definition needs to have the symbol in lower-case for uniqueness.

### Sample symbol CSV file
```
STXTPT, "txtptr"="txttab"-1
LIST, LIST instruction
GOLST, (Convert char. $ to # in 11-12)
LSTEND, +
TSTDUN, (done?)
TYPLIN, (Print the integer in A,X)
PRIT4, +
PLOOP, (Print character in A)
PLOOP1, +
GRODY, (Jump to "ready")
QPLOP, +
```

With a symbol file one just adds an additional input arg with the header name 'COMMENT' or 'DESC' and mkmmap treats those as a special case.

The command:

```
./mkmmap 1.0,PET1.txt 2.0,PET2.txt 4.0,PET4.txt VIC20,VIC20.txt C64,C64-03.txt COMMENT,all_symbols.csv | (sed -u 1q; sort -k4,4 -k3,3 -k2,2)
```

Will produce output similar to:

```
VALTYP    $005E   $0007   $0007   $000D   $000D   Flag for variable type: 00=numeric; ff=string
INTFLG    $005F   $0008   $0008   $000E   $000E   Flag for # type: 80=integer; 00=floating point
DORES     $0060   $0009   $0009   $000F   $000F   Flag whether can crunch reserved words
GARBFL    $0060   $0009   $0009   $000F   $000F   x
SUBFLG    $0061   $000A   $000A   $0010   $0010   Flag which allows subscripts in syntax (FNX flag)
INPFLG    $0062   $000B   $000B   $0011   $0011   Flags input or read (00=INPUT; 40=GET; 98=READ)
DOMASK    $0063   $000C   $000C   $0012   $0012   Mask used by relation operations (Comparison Evaluation Flag)
TANSGN    $0063   $000C   $000C   $0012   $0012   Flag sign of tangent
DSDESC     ----    ----   $000D    ----    ----   ds$ length
CHANL      ----   $000E   $0010    ----    ----   Active I/O Channel #
.
.
.
FOR       $C649   $C658   $B6DE   $C742   $A742   FOR instruction
NOTOL     $C65A   $C669   $B6EF   $C753   $A753   +
LDFONE    $C692   $C6A1   $B727   $C78B   $A78B   (Continue to build FOR vectors)
ONEON     $C6A6   $C6B5   $B73B   $C79F   $A79F   (Extract a FAC sign)
NEWSTT    $C6B5   $C6C4   $B74A   $C7AE   $A7AE   Read & execute next statement
DIRCON    $C6C4   $C6D4   $B759   $C7BE   $A7BE   +
DIRCN1     ----   $C6E4   $B769   $C7CE   $A7CE   +
GONE      $C6E9   $C6F7   $B77C   $C7E1   $A7E1   Dispatches next byte "chrget" returns
GONE3     $C6F2   $C700   $B785   $C7ED   $A7ED   Dispatches A if <>0 else loop to "newstt"
GONE2     $C6F5   $C702   $B787   $C7EF   $A7EF   (Entry from b8e7)
GONE4      ----    ----   $B795    ----    ----   +
GLET      $C6F9   $C717   $B7A2   $C804   $A804   (Jump to perform LET)
MORSTS    $C6C8   $C71A   $B7A5   $C807   $A807   (A ":"?)
SNERR1    $C6CC   $C71E   $B7A9   $C80B   $A80B   (Jump to print "syntax error")
GO         ----   $FECF   $B7AC    ----    ----   Handle GO token - find a TO
RESTOR    $C70D   $C730   $B7B7   $C81D   $A81D   RESTORE statement
RESFIN    $C717   $C73A   $B7C1   $C827   $A827   (Entry from bce2)
ISCRTS    $C71B   $C73E   $B7C5   $C82B   $A82B   (End of RESTORE)
STOP      $C71C   $C73F   $B7C6   $C82F   $A82F   STOP instruction if carry set - else...
BSTOP     $C71C   $C73F   $B7C6    ----    ----   O.S. Substitute: "stop" is also a label at $f343
```

The historic comments from 1981 are somewhat stylistically inconsistent.  Some edits have been made, but in the future, a nice, clean, edited copy would be nice.  In addition to meaningful text contents, the original comments used "+" as a continuation character from the previous comment in blocks of code where there aren't specific callable entry-points.  On top of that, the use of "x" is something of a visible place-holder for symbols that never had a comment in the 1981 list, or ones that slipped through the cracks when processing the files for this repo.  Some comments are new and are intended to be used to filter out lines that are largely uninformative such as constants defined in the original source code that do not correspond to items in the memory map, or local symbols that exist in the code but are not helpful to be highlighted.

One unimplemented feature in the 1981 list is multi-line comments. Presently, all output lines begin with a symbol or an address.

Also, as part of the disambiguation mechanism for symbols that appear twice (in the BASIC listing and in the KERNEL listing), some symbols are printed out in lower case.  The second appearance must be in lower case in the symbol CSV file to line up the correct values, but an upcoming feature will be to output all symbols in upper case regardless of how they appear in the symbol CSV file.
