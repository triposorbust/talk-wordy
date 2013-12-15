#ifndef __SPEAKER_H__
#include "speaker.h"
#endif

static char BUFFER [2048];

int main (int argc, char **argv)
{
  if (argc == 1) {
    printf("Usage:\n$ ./speaker <tcp-socket>\n");
    exit (-1);
  }
  
  void *context = zmq_ctx_new ();
  void *puller = zmq_socket (context, ZMQ_PULL);
  void *sender = zmq_socket (context, ZMQ_PAIR);
  int rc = zmq_bind (puller, argv [1]);
  assert (rc == 0);
  rc = zmq_connect (sender, "ipc://oasis.ipc");
  assert (rc == 0);

  while (1) {
    memset (BUFFER, '\0', 2048);
    char *string = s_recv (puller);
    strncpy (BUFFER, string, 2047);
    free (string);

    s_send (sender, BUFFER);
    if (0 == strlen (BUFFER))
      break;
  }

  zmq_close (sender);
  zmq_close (puller);
  zmq_ctx_destroy (context);
  return 0;
}
