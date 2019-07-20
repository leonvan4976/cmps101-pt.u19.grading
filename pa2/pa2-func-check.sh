#!/usr/bin/bash

SRCDIR=https://raw.githubusercontent.com/houi-lin/cmps101-pt.u19.grading/master/pa2
NUMTESTS=5
PNTSPERTEST=2
let MAXPTS=$NUMTESTS*$PNTSPERTEST
TIME=5

if [ ! -e backup ]; then
  mkdir backup
fi

cp *.c *.h Makefile backup   # copy all files of importance into backup

for NUM in $(seq 1 $NUMTESTS); do
  curl $SRCDIR/infile$NUM.txt > infile$NUM.txt
  curl $SRCDIR/model-outfile$NUM.txt > model-outfile$NUM.txt
  rm -f outfile$NUM.txt
done


rm -f *.o Sparse

gcc -c -Wall -std=c99 -g Sparse.c Matrix.c List.c
gcc -o Sparse Sparse.o Matrix.o List.o


echo ""
echo ""

sparsepassed=$(expr 0)
echo "Please be warned that the following tests discard all output to stdout/stderr"
echo "Sparse tests: If nothing between '=' signs, then test is passed"
echo "Press enter to continue"
read verbose
for NUM in $(seq 1 $NUMTESTS); do
  rm -f outfile$NUM.txt
  let RUNTIME=$TIME
  if [ $NUM -eq 4 ]; then
    let RUNTIME=3*$TIME
  fi
  timeout $RUNTIME Sparse infile$NUM.txt outfile$NUM.txt &> garbage >> garbage #all stdout/stderr thrown away
  diff -bBwu outfile$NUM.txt model-outfile$NUM.txt > diff$NUM.txt &>> diff$NUM.txt
  echo "Sparse Test $NUM:"
  echo "=========="
  cat diff$NUM.txt
  echo "=========="
  if [ -e diff$NUM.txt ] && [[ ! -s diff$NUM.txt ]]; then # increment number of tests passed counter
    let sparsepassed+=1
  fi
done

echo ""
echo ""

let sparsetestspoints=$PNTSPERTEST*$sparsepassed
if [ "$sparsetestspoints" -gt "$MAXPTS" ]; then # max 10 points
  let sparsetestspoints=$(expr $MAXPTS)
fi
echo "Passed $sparsepassed Sparse tests for a total of $sparsetestspoints / $MAXPTS points"

echo ""
echo ""

rm -f *.o ModelListTest* ModelMatrixTest* Sparse garbage
