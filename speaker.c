#ifndef __SPEAKER_H__
#include "speaker.h"
#endif

static char BUFFER [2048];
static const int PROCESSES = 1;

void loop (char *address)
{
  void *context = zmq_ctx_new ();
  void *puller = zmq_socket (context, ZMQ_PULL);
  void *publisher = zmq_socket (context, ZMQ_PUB);
  int rc = zmq_bind (puller, address);
  assert (rc == 0);
  rc = zmq_bind (publisher, "ipc://oasis.ipc");
  assert (rc == 0);

  while (1) {
    memset (BUFFER, '\0', 2048);
    char *string = s_recv (puller);
    strncpy (BUFFER, string, 2047);
    free (string);

    printf ("speak: %s\n", BUFFER);
    s_send (publisher, BUFFER);
    if (0 == strlen (BUFFER))
      break;
  }

  zmq_close (publisher);
  zmq_close (puller);
  zmq_ctx_destroy (context);
}

int main (int argc, char **argv)
{
  if (argc == 1) {
    printf("Usage:\n$ ./speaker <tcp-socket>\n");
    exit (-1);
  }

  int process;
  for (process=0; process<PROCESSES; ++process) {
    pid_t pid = fork();
    if (pid < 0) {
      exit (-1);
    } else if (0 == pid) {
      execl ("synth", "synth", (char *) NULL);
      exit (-1);
    }
  }
  
  loop (argv [1]);

  int status;
  pid_t wpid;
  for (process=0; process<PROCESSES; ++process) {
    wpid = wait (&status);
  }
  return 0;
}
