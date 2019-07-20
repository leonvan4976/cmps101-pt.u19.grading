#!/usr/bin/bash

SRCDIR=https://raw.githubusercontent.com/houi-lin/cmps101-pt.u19.grading/master/pa2
let MAXPTS=10
TIME=5

if [ ! -e backup ]; then
  mkdir backup
fi

cp *.c *.h Makefile backup   # copy all files of importance into backup

curl $SRCDIR/ModelListTest.c > ModelListTest.c

echo ""
echo ""

rm -f *.o Sparse

echo ""

echo "Press Enter To Continue with ListTest Results"
read verbose

gcc -c -std=c99 -Wall -g ModelListTest.c List.c
gcc -o ModelListTest ModelListTest.o List.o

timeout $TIME valgrind --leak-check=full -v ./ModelListTest -v

echo ""
echo ""

rm -f *.o ModelListTest* ModelMatrixTest* Sparse garbage
