#!/bin/sh

# petmap.sh
#
# Full-featured example of mkmmap, combining three concatenated listing
# file (BASIC + KERNAL) and a comments CSV file, with filtering and sorting

./mkmmap 1.0,listings/PET1.txt\
         2.0,listings/PET2.txt\
         4.0,listings/PET4.txt\
         COMMENT,pet_symbols_1981.csv |\
         grep -v "constant)" |\
         grep -v "dup symb" |\
         (sed -u 1q; sort -k4,4 -k3,3 -k2,2)


