#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main (int argc, char **argv)
{
  int i;
  for (i=1; i<argc; ++i) {
    pid_t pid = fork();
    if (pid == 0) {
      execl ("/usr/bin/say", "say", argv [i], (char *) NULL);
    }
  }

  int status;
  for (i=1; i<argc; ++i) {
    wait (&status);
  }
  return 0;
}
