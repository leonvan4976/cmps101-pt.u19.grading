#!/usr/bin/bash

SRCDIR=https://raw.githubusercontent.com/houi-lin/cmps101-pt.u19.grading/master/pa2

if [ ! -e backup ]; then
  mkdir backup
fi

cp *.c *.h Makefile backup   # copy all files of importance into backup


echo ""
echo ""

rm -f *.o Sparse

make

if [ ! -e Sparse ] || [ ! -x Sparse ]; then # exist and executable
  echo ""
  echo "Makefile probably doesn't correctly create Executable called \"Sparse\"!!!"
  echo ""
else
  echo ""
  echo "Makefile probably correctly creates Executable!"
  echo ""
fi

echo ""
echo ""

make clean

if [ -e Sparse ] || [ -e *.o ]; then
  echo "WARNING: Makefile didn't successfully clean all files"
fi

rm -f *.o ModelListTest* ModelMatrixTest* Sparse garbage
