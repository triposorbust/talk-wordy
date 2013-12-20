#ifndef __SPEAKER_H__
#include "speaker.h"
#endif

static char BUFFER [2048];

void loop (char *tcp, char *ipc)
{
  void *context = zmq_ctx_new ();
  void *responder = zmq_socket (context, ZMQ_REP);
  void *requester = zmq_socket (context, ZMQ_REQ);
  int rc = zmq_connect (responder, tcp);
  assert (rc == 0);
  rc = zmq_connect (requester, ipc);
  assert (rc == 0);

  while (1) {
    char *string = s_recv (responder);
    time_t start = time (NULL);
    memset (BUFFER, '\0', 2048);
    strncpy (BUFFER, string, 2047);
    free (string);

    printf ("send: %s\n", BUFFER);
    s_send (requester, BUFFER);
    if (0 == strlen (BUFFER))
      break;

    string = s_recv (requester);
    printf ("recv: %s\n", string);
    free (string);

    double elapsed = difftime (time (NULL), start);
    char *response = (char *) malloc (25 * sizeof(char));
    memset (response, '\0', 25);
    snprintf (response, 25, "%d", (int) elapsed);
    s_send (responder, response);
    free (response);
  }

  zmq_close (requester);
  zmq_close (responder);
  zmq_ctx_destroy (context);
}

int main (int argc, char **argv)
{
  if (argc != 3) {
    printf("Usage:\n$ ./speaker <tcp> <ipc>\n");
    exit (-1);
  }

  pid_t pid = fork();
  if (pid < 0) {
    exit (-1);
  } else if (0 == pid) {
    execl ("synth", "synth", argv [2], (char *) NULL);
    exit (-1);
  }
  
  loop (argv [1], argv [2]);

  int status;
  pid_t wpid = waitpid (pid, &status, 0);
  assert (pid == wpid);

  return 0;
}
