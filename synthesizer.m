#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import <zmq.h>
#import <assert.h>
#import "zstring.h"

int main (void)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];

  void *context = zmq_ctx_new ();
  void *subscriber = zmq_socket (context, ZMQ_SUB);
  int rc = zmq_connect (subscriber, "ipc://oasis.ipc");
  assert (rc == 0);
  rc = zmq_setsockopt (subscriber, ZMQ_SUBSCRIBE, "", 0);
  assert (rc == 0);

  while (1) {
    char *string = s_recv (subscriber);
    printf ("synth: %s\n", string);

    NSString *wrapped = [NSString stringWithUTF8String:string];
    NSUInteger length = [wrapped length];

    [synth startSpeakingString:wrapped];
    while ([synth isSpeaking])
      [NSThread sleepForTimeInterval:0.1];
    [wrapped autorelease];

    free (string);
    if (length == 0)
      break;
  }

  zmq_close (subscriber);
  zmq_ctx_destroy (context);

  [synth autorelease];

  [NSThread sleepForTimeInterval:0.2];
  [pool release];
  return 0;
}
