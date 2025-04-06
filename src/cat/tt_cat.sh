#!/bin/bash
gcc -Wall -Wextra -Werror -std=c11 s21_cat.c -o s21_cat

PROGRAM="./s21_cat"

run_test() {
    local flag=$1
    local file=$2
    local my_output_file="my_output.txt"
    local original_output_file="original_output.txt"

    $PROGRAM $flag $file > $my_output_file 2>&1

    cat $flag $file > $original_output_file 2>&1

    if diff -q $my_output_file $original_output_file > /dev/null; then
        echo "+    Тест с флагом '$flag' и файлом '$file' пройден"
    else
        echo "-    Тест с флагом '$flag' и файлом '$file' не пройден"
        echo "Различия:"
        diff $my_output_file $original_output_file
    fi
}

run_test -b test.txt
run_test -n test.txt
run_test -t test.txt
run_test -s test.txt
run_test -v test.txt
run_test -e test.txt
run_test -ev test.txt
run_test -tv test.txt
run_test -ev test.txt

run_test -b 3.file
run_test -n 3.file
run_test -t 3.file
run_test -s 3.file
run_test -v 3.file
run_test -n 3.file
run_test -e 3.file
run_test -ev 3.file
run_test -tv 3.file
run_test -ev 3.file

run_test -b 4.file
run_test -n 4.file
run_test -t 4.file
run_test -s 4.file
run_test -v 4.file
run_test -n 4.file
run_test -e 4.file
run_test -ev 4.file
run_test -tv 4.file
run_test -ev 4.file

rm -f my_output.txt original_output.txt
