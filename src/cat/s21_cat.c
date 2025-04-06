#include "s21_cat.h"

struct flags {
  int s;
  int b;
  int e;
  int n;
  int t;
  int v;
};

const struct option long_options[] = {{"number-nonblank", no_argument, 0, 'B'},
                                      {"number", no_argument, 0, 'N'},
                                      {"squeeze-blank", no_argument, 0, 'S'},
                                      {0, 0, 0, 0}};

void write_file(char path[]) {
  FILE *my_file = fopen(path, "r");
  if (my_file != NULL) {
    char letter = fgetc(my_file);
    while (letter != EOF) {
      printf("%c", letter);
      letter = fgetc(my_file);
    }
    fclose(my_file);
  }
}

struct flags parse_line(int argc, char *argv[], int *index_first_file) {
  struct flags F = {0, 0, 0, 0, 0, 0};
  *index_first_file = 0;

  int c;

  while ((c = getopt_long(argc, argv, "+bEnsT::BNSe::t::v::", long_options,
                          NULL)) != -1) {
    switch (c) {
      case 'b':
        F.b = 1;
        break;
      case 'n':
        F.n = 1;
        break;
      case 's':
        F.s = 1;
        break;
      case 'E':
        F.e = 1;
        break;
      case 'T':
        F.t = 1;
        break;
      case 'B':
        F.b = 1;
        break;
      case 'S':
        F.s = 1;
        break;
      case 'N':
        F.n = 1;
        break;
      case 'e':
        F.e = 1;
        F.v = 1;
        break;
      case 't':
        F.t = 1;
        F.v = 1;
        break;
      case 'v':
        if (optarg == 0)
          F.v = 1;
        else {
          if (strcmp(optarg, "e") == 0)
            F.e = 1;
          else if (strcmp(optarg, "t") == 0) {
            F.t = 1;
          }
        }
        break;
    }
  }
  *index_first_file = optind;
  return F;
}

void print_file(char *name, struct flags FLAGS) {
  FILE *f = fopen(name, "r");

  if (f != NULL) {
    int index = 1;
    int emptry_prev_line = 0;
    char c = fgetc(f), prev = '\n';
    while (c != EOF) {
      print_char(c, &prev, FLAGS, &index, &emptry_prev_line);
      c = fgetc(f);
    }
    fclose(f);
  } else {
    printf("cat: %s: No such file or directory\n", name);
  }
}

void print_char(int c, char *prev, struct flags F, int *index,
                int *empty_prev_line) {
  int N_before_E = 0;

  if (F.b && F.n) F.n = 0;
  if (F.n && F.e && !F.b) {
    N_before_E = 1;
  }

  if (!(F.s && *prev == '\n' && c == '\n' && *empty_prev_line)) {
    if (*prev == '\n' && c == '\n' && *empty_prev_line == 0) {
      *empty_prev_line = 1;
    } else {
      *empty_prev_line = 0;
    }
    if (F.e == 1 && !N_before_E) {
      if (c == '\n') {
        if ((F.b || F.n) && *prev == '\n') printf("\t");
        printf("$");
      }
    }
    if (F.b == 1) {
      if (c != '\n' && *prev == '\n') {
        if (*index < 10)
          printf("     %d	", *index);
        else if (*index <= 99)
          printf("    %d	", *index);
        else if (*index <= 999)
          printf("   %d	", *index);
        else
          printf("  %d	", *index);

        *index = (*index) + 1;
      }
    }

    if (F.n == 1) {
      if (*prev == '\n') {
        if (*index < 10)
          printf("     %d	", *index);
        else if (*index <= 99)
          printf("    %d	", *index);
        else if (*index <= 999)
          printf("   %d	", *index);
        else
          printf("  %d	", *index);

        *index = (*index) + 1;
      }
    }

    if (N_before_E && F.e) {
      if (c == '\n') {
        printf("$");
      }
    }

    if (F.t == 1 && c == '\t') {
      printf("^");
      c = 'I';
    }

    if (F.v == 1) {
      if (c >= 0 && c <= 31 && c != '\n' && c != '\t') {
        printf("^");
        c = c + 64;
      } else if (c == 127) {
        printf("^");
        c = '?';
      }
    }
    printf("%c", c);
  }
  *prev = c;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Not enough argumants");
  } else {
    int index_file = 1;
    struct flags F = parse_line(argc, argv, &index_file);

    for (int i = index_file; i < argc; i++) {
      if (index_file == 1)
        write_file(argv[i]);
      else
        print_file(argv[i], F);
    }
  }
  return 0;
}
