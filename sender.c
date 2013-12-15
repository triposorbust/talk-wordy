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
  void *requester = zmq_socket (context, ZMQ_REQ);
  int rc = zmq_connect (requester, argv [1]);
  assert (rc == 0);

  int length;
  while (1) {
    memset (BUFFER, '\0', 2048);
    gets (BUFFER);
    length = s_send (requester, BUFFER);

    if (0 == length)
      break;

    char *string = s_recv (requester);
    printf ("%s\n", string);
    free (string);
  }

  zmq_close (requester);
  zmq_ctx_destroy (context);
  return 0;
}
