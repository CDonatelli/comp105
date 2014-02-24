#!/bin/bash

# -- Change these paths as you see fit
TESTDIR=./
IMPCORE=/comp/105/files/bin/impcore

echo '=== Assignment 1 Test Script ==='

echo ''
echo '--- Test exercise 3 ---'
cat ex3.ic $TESTDIR/ex3test.ic | $IMPCORE -q

echo ''
echo '--- Test exercise 4 ---'
cat ex4.ic $TESTDIR/ex4test.ic | $IMPCORE -q

echo ''
echo '--- Test exercise 5 ---'
cat ex5.ic $TESTDIR/ex5test.ic | $IMPCORE -q

echo ''
echo '--- Test exercise 6 ---'
cat ex6.ic $TESTDIR/ex6test.ic | $IMPCORE -q

echo ''
echo '--- Test exercise 7 ---'
cat ex7.ic $TESTDIR/ex7test.ic | $IMPCORE -q

echo ''
echo '--- Test exercise 8 ---'
cat ex8.ic $TESTDIR/ex8test.ic | $IMPCORE -q
