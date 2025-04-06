FLAGS=-std=c11 -Wall -Wextra -Werror
TARGET=s21_cat
CC=gcc

all: s21_cat

s21_grep: s21_cat.c
	$(CC) $(FLAGS) s21_cat.c -o $(TARGET)

rebuild: clean s21_cat

clang:
	cp ../../materials/linters/.clang-format .clang-format
	clang-format -i *.c *.h
	rm -rf .clang-format

test:
	bash tt_cat.sh

clean:
	rm $(TARGET)
