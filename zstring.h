#ifndef __ZSTRING_H__
#define __ZSTRING_H__

#ifndef __STRING_H__
#define __STRING_H__
#include <string.h>
#endif

static char *
s_recv (void *socket) {
  char buffer [2048];
  int size = zmq_recv (socket, buffer, 2048, 0);
  if (size == -1)
    return NULL;
  if (size > 2048)
    size = 2048;
  buffer [size] = 0;
  return strdup (buffer);
}

static int
s_send (void *socket, char *string) {
  int size = zmq_send (socket, string, strlen (string), 0);
  return size;
}

#endif
