#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void write_file(char path[]);
struct flags parse_line(int argc, char *argv[], int *index_first_file);
void print_file(char *name, struct flags FLAGS);
void print_char(int c, char *prev, struct flags F, int *index,
                int *eline_printed);