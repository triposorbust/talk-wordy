#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import <zmq.h>
#import <time.h>
#import <assert.h>
#import "zstring.h"

int main (void)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSString *voice;
  NSUInteger index;
  NSSpeechSynthesizer *synth;

  index = arc4random() % [[NSSpeechSynthesizer availableVoices] count];
  voice = [[NSSpeechSynthesizer availableVoices] objectAtIndex:index];
  synth = [[NSSpeechSynthesizer alloc] initWithVoice:voice];
  [voice autorelease];

  void *context = zmq_ctx_new ();
  void *responder = zmq_socket (context, ZMQ_REP);
  int rc = zmq_bind (responder, "ipc://oasis.ipc");
  assert (rc == 0);

  while (1) {
    char *string = s_recv (responder);
    time_t start = time (NULL);
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

    double elapsed = difftime (time (NULL), start);
    char *response = (char *) malloc (100 * sizeof(char));
    memset (response, '\0', 100);
    snprintf (response, 100, "%d", (int) elapsed);
    s_send (responder, response);
    free (response);
  }

  zmq_close (responder);
  zmq_ctx_destroy (context);

  [synth autorelease];

  [NSThread sleepForTimeInterval:0.2];
  [pool release];
  return 0;
}
