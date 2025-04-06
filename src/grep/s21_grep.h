#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 4000
#define MAX_TEMPLATES 100
#define MAX_TEMP_LEN 100

struct parameters parse_line(int argc, char *argv[]);
void search_no_flags(char *name, char *temp, int some_files);
int match_line(const char *line, char *template, int flag_i);
void search_with_flags(char *name, struct parameters F, int some_files);
int match_any_template(const char *line, struct parameters *F);
void implement_flags(char *fname, struct parameters *F, int several_files);