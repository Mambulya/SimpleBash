#include "s21_grep.h"

struct parameters {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;

  char templates[MAX_LINE][MAX_TEMP_LEN];
  int templates_count;
  int ind;

  int index_not_flag;
  int index_first_file;
};

struct parameters parse_line(int argc, char *argv[]) {
  struct parameters F = {0};
  F.index_not_flag = 0;
  F.templates_count = 0;
  int c;
  while ((c = getopt(argc, argv, "vnlce:i")) != -1) {
    switch (c) {
      case 'e':
        F.e = 1;
        strncpy(F.templates[F.ind], optarg, sizeof(F.templates[F.ind]));
        F.templates_count++;
        F.ind++;
        break;
      case 'i':
        F.i = 1;
        break;
      case 'v':
        F.v = 1;
        break;
      case 'c':
        F.c = 1;
        break;
      case 'l':
        F.l = 1;
        break;
      case 'n':
        F.n = 1;
        break;
    }
  }
  F.index_not_flag = optind;
  return F;
}

void search_no_flags(char *name, char *temp, int some_files) {
  FILE *file = fopen(name, "r");
  if (file == NULL)
    printf("No such file or directory\n");
  else {
    char line[MAX_LINE];
    regex_t reg;
    regcomp(&reg, temp, 0);

    while (fgets(line, sizeof(line), file) != NULL) {
      int res = regexec(&reg, line, 0, NULL, 0);
      if (res == 0) {  // template found
        if (some_files) printf("%s:", name);
        printf("%s", line);
        if (!strchr(line, '\n')) printf("\n");
      }
    }
    regfree(&reg);
    fclose(file);
  }
}

int match_line(const char *line, char *template, int flag_i) {
  int res = 0;
  regex_t reg;
  if (flag_i)
    regcomp(&reg, template, REG_ICASE);
  else
    regcomp(&reg, template, 0);
  res = regexec(&reg, line, 0, NULL, 0);
  regfree(&reg);
  return !res;
}

int match_any_template(const char *line, struct parameters *F) {
  int res = 0;
  for (int i = 0; i < F->templates_count; i++) {
    if (match_line(line, F->templates[i], F->i)) {
      res = 1;
      // break;
    }
  }
  return res;
}

void implement_flags(char *fname, struct parameters *F, int several_files) {
  FILE *ffile = fopen(fname, "r");
  if (ffile != NULL) {
    int total_paterns = 0;
    int total_lines = 1;
    char lline[MAX_LINE];

    while (fgets(lline, sizeof(lline), ffile) != NULL) {
      int suitable = match_any_template(lline, F);
      if (F->v) suitable = !suitable;
      if (suitable) total_paterns++;
      if (F->n && !F->c && !F->l) {
        if (suitable) {
          if (several_files) printf("%s:", fname);
          printf("%d:%s", total_lines, lline);
          if (!strchr(lline, '\n')) printf("\n");
        }
      }
      if ((F->v || F->e || F->i) && !F->l && !F->c && !F->n && suitable) {
        if (several_files) printf("%s:", fname);
        printf("%s", lline);
        if (!strchr(lline, '\n')) printf("\n");
      }
      total_lines++;
    }

    if (F->c && !F->l) {
      if (several_files) printf("%s:", fname);
      printf("%d\n", total_paterns);
    }
    if (F->l && total_paterns) {
      printf("%s\n", fname);
    }
  } else {
    printf("%s", "No such file or directory");
  }
}

int main(int argc, char *argv[]) {
  if (argc < 3) {
    perror("Not enough arguments");
  } else {
    struct parameters F = {0};
    F = parse_line(argc, argv);

    if (optind == 1) {
      char *template = argv[optind];
      int several_files = 0;
      if (argc - optind > 2) several_files = 1;
      for (int i = optind + 1; i < argc - optind + 1; i++)
        search_no_flags(argv[i], template, several_files);

    } else {
      int several_f = 0;
      if (strcmp(argv[optind - 2], "-e") == 0) {
        F.index_first_file = optind;
      } else if (F.e) {
        F.index_first_file = optind;
      } else {
        strncpy(F.templates[F.ind], argv[optind],
                sizeof(F.templates[F.ind]) - 1);
        F.ind++;
        F.templates_count++;
        F.index_first_file = optind + 1;
      }

      if (argc - F.index_first_file > 1) several_f = 1;
      implement_flags(argv[F.index_first_file], &F, several_f);
    }
  }
  return 0;
}
