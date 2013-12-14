#ifndef __SENDER_H__
#include "sender.h"
#endif

static char BUFFER [2048];

int main (int argc, char **argv)
{
  if (argc == 1) {
    printf ("Usage:\n$ ./sender <tcp-socket>\n");
    exit (-1);
  }

  void *context = zmq_ctx_new ();
  void *pusher = zmq_socket (context, ZMQ_PUSH);
  int rc = zmq_bind (pusher, argv [1]);
  assert (rc == 0);

  while (1) {
    memset (BUFFER, '\0', 2048);
    gets (BUFFER);
    if (0 == strlen (BUFFER))
      break;
    s_send (pusher, BUFFER);
  }

  zmq_close (pusher);
  zmq_ctx_destroy (context);
  return 0;
}
