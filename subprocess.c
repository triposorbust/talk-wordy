#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main (int argc, char **argv)
{
  pid_t pid = fork();
  if (pid == 0) {
    execv ("/usr/bin/say", & argv [0]);
  }
  int status;
  pid_t wpid = waitpid (pid, &status, 0);
  assert (pid == wpid);
  return 0;
}
