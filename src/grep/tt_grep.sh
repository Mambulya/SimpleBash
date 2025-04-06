#!/bin/bash
gcc -Wall -Wextra -Werror -std=c11 s21_grep.c -o s21_grep
PROGRAM="./s21_grep"

TEST_FILES=("test1.txt" "test2.txt")

ORIGINAL_OUTPUT_FILE="original_grep_output.txt"
MY_GREP_OUTPUT_FILE="my_grep_output.txt"

run_test() {
    local flags="$1"
    local pattern="$2"
    local file="$3"

    echo "Testing with flags: '$flags', pattern: '$pattern', file: '$file'"

    grep $flags "$pattern" "$file" > $ORIGINAL_OUTPUT_FILE

    $PROGRAM $flags "$pattern" "$file" > $MY_GREP_OUTPUT_FILE

    if diff -q $ORIGINAL_OUTPUT_FILE $MY_GREP_OUTPUT_FILE; then
        echo "+     SUCCESS"
    else
        echo "-     FAIL"
        echo "Differences:"
        diff $ORIGINAL_OUTPUT_FILE $MY_GREP_OUTPUT_FILE
    fi
    echo
}

compare_outputs() {
    local f1=$1
    local f2=$2

    if diff -q $f1 $f2; then
        echo "+     SUCCESS"
    else
        echo "-     FAIL"
        diff $f1 $f2
    fi
    echo
}

echo "----------------NO FLAGS-------------------"
echo "Testing pattern: 'Test', file: 'test1.txt'"
$PROGRAM "Test" "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
$PROGRAM "Test" "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "----------------COMBINED FLAGS-------------------"
run_test -iv Test "${TEST_FILES[0]}"
run_test -ni Test "${TEST_FILES[1]}"
run_test -il Test "${TEST_FILES[0]}"
run_test -ic Test "${TEST_FILES[1]}"
run_test -vn Test "${TEST_FILES[0]}"
run_test -vl Test "${TEST_FILES[1]}"
run_test -vc Test "${TEST_FILES[0]}"
run_test -nl Test "${TEST_FILES[1]}"
run_test -nc Test "${TEST_FILES[0]}"

echo "----------------MONO FLAGS-------------------"
run_test -i hello "${TEST_FILES[0]}"
run_test -c Test "${TEST_FILES[0]}"
run_test -n Test "${TEST_FILES[0]}"
run_test -l Test "${TEST_FILES[0]}"
run_test -e Test "${TEST_FILES[0]}"
run_test -v Test "${TEST_FILES[0]}"

run_test -c grep "${TEST_FILES[1]}"
run_test -n grep "${TEST_FILES[1]}"
run_test -i grep "${TEST_FILES[1]}"
run_test -e grep "${TEST_FILES[1]}"
run_test -l grep "${TEST_FILES[1]}"

run_test -c "1" "${TEST_FILES[1]}"
run_test -l "Testt" "${TEST_FILES[1]}"
run_test -e "____Test____" "${TEST_FILES[1]}"
run_test -i "____Test____" "${TEST_FILES[1]}"
run_test -n "____Test____" "${TEST_FILES[1]}"

echo "----------------DOUBLE FLAGS-------------------"
echo "Testing with flags: -n -i, pattern: '[1-9]', file: 'test1.txt'"
$PROGRAM -n -i tEst "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -n -i tEst "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -n -l, pattern: '(Test|programming)', file: 'test1.txt'"
$PROGRAM -n -l "(Test|programming)" "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -n -l "(Test|programming)" "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -n -c, pattern: '[[:punct:]]', file: 'test1.txt'"
$PROGRAM -n -c [[:punct:]] "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -n -c [[:punct:]] "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -n -e, pattern: 'Test', file: 'test1.txt'"
$PROGRAM -n -e Test "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -n -e Test "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -e -i, pattern: '[A-Z]', file: 'test1.txt'"
$PROGRAM -e [A-Z] -i "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -e [A-Z] -i "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -e -c, pattern: '[A-Za-z]{4,}', file: 'test1.txt'"
$PROGRAM -e "[A-Za-z]{4,}" -c "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -e "[A-Za-z]{4,}" -c "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE


echo "Testing with flags: -e -l, pattern: 'Test', file: 'test1.txt'"
$PROGRAM -e Test -l "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -e Test -l "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -i -l, pattern: 'Test', file: 'test1.txt'"
$PROGRAM -i -l "Test" "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -i -l "Test" -l "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -i -c, pattern: 'TeSt', file: 'test1.txt'"
$PROGRAM -i -l "TeSt" "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -i -l "TeSt" "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "----------------TRIPLE FLAGS-------------------"

echo "Testing with flags: -c -n -e, pattern: '\d{3}', file: 'test1.txt'"
$PROGRAM -c -n -e "\d{3}" "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -c -n -e "\d{3}" "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -i -e -n, pattern: '[0-9]{2,}', file: 'test1.txt'"
$PROGRAM -i -e "[0-9]{2,}" -n "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -i -e "[0-9]{2,}" -n "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE

echo "Testing with flags: -v -e -n, pattern: '[0-9]{2,}', file: 'test1.txt'"
$PROGRAM -v -e "[0-9]{2,}" -n "${TEST_FILES[0]}" > $MY_GREP_OUTPUT_FILE
grep -v -e "[0-9]{2,}" -n "${TEST_FILES[0]}" > $ORIGINAL_OUTPUT_FILE
compare_outputs $MY_GREP_OUTPUT_FILE $ORIGINAL_OUTPUT_FILE


rm $ORIGINAL_OUTPUT_FILE $MY_GREP_OUTPUT_FILE