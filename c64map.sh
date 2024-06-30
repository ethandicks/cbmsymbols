#!/bin/sh

# c64map.sh
#
# Full-featured example of mkmmap, combining three concatenated listing
# file (BASIC + KERNAL) for three versions of C64 KERNAL, and a comments
# CSV file, with filtering and sorting

cat pet_symbols_1981.csv c64_symbols_1983.csv >all_symbols_temp.csv

./mkmmap MAY82,listings/C64-01.txt\
         JUL82,listings/C64-02.txt\
         AUG83,listings/C64-03.txt\
         COMMENT,all_symbols_temp.csv |\
         grep -v "constant)" |\
         grep -v "dup symb" |\
         (sed -u 1q; sort -k4,4 -k3,3 -k2,2)


