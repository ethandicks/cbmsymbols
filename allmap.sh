#!/bin/sh

# allmap.sh
#
# Full-featured example of mkmmap, combining three PET concatenated listing
# file (BASIC + KERNAL), VIC-20 concatenated listing file, C64 concatenated
# listing file, and two comments CSV files, with filtering and sorting

cat pet_symbols_1981.csv c64_symbols_1983.csv >all_symbols_temp.csv

./mkmmap 1.0,listings/PET1.txt\
         2.0,listings/PET2.txt\
         4.0,listings/PET4.txt\
	 VIC20,listings/VIC20.txt\
	 C64,listings/C64-03.txt\
         COMMENT,all_symbols_temp.csv |\
         grep -v "constant)" |\
         grep -v "dup symb" |\
	 (sed -u 1q; sort -k4,4 -k3,3 -k2,2 -k5,5 -k6,6)

