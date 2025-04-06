TARGET=s21_grep
CC = gcc
FLAGS=-Wall -Werror -Wextra -std=c11

all:s21_grep

s21_grep:s21_grep.c
	$(CC) $(FLAGS) s21_grep.c
	$(CC) $(FLAGS) s21_grep.c -o $(TARGET)
  
rebuild:clean s21_grep

clang: 
	cp ../../materials/linters/.clang-format .clang-format
	clang-format -i *.c *.h
	rm -rf .clang-format

test:
	bash tt_grep.sh

clean:
	rm $(TARGET)
