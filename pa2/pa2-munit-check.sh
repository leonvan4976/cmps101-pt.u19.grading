#!/usr/bin/bash
TIME=8

SRCDIR=https://raw.githubusercontent.com/houi-lin/cmps101-pt.u19.grading/master/pa2

if [ ! -e backup ]; then
  mkdir backup
fi

cp *.c *.h Makefile backup   # copy all files of importance into backup

curl $SRCDIR/ModelMatrixTest.c > ModelMatrixTest.c

echo ""
echo ""

rm -f *.o

echo "Press Enter To Continue with MatrixTest Results"
read verbose

echo ""
echo ""

gcc -c -std=c99 -Wall -g ModelMatrixTest.c Matrix.c List.c
gcc -o ModelMatrixTest ModelMatrixTest.o Matrix.o List.o

timeout $TIME valgrind --leak-check=full -v ./ModelMatrixTest -v

rm -f *.o ModelMatrixTest* ModelMatrixTest*
