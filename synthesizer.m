#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import <zmq.h>
#import <time.h>
#import <assert.h>
#import "zstring.h"

int main (int argc, char **argv)
{
  assert (argc == 2);
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *voices = [[NSArray alloc]
                     initWithObjects:@"Alex",@"Boing",@"Bruce",@"Fred",
                     @"Junior",@"Princess",@"Ralph",@"Trinoids",@"Vicki",
                     @"Victoria",@"Zarvox",nil];
  NSSpeechSynthesizer *synth;

  NSUInteger index = arc4random() % [voices count];
  NSString *voice = [@"com.apple.speech.synthesis.voice."
                     stringByAppendingString:[voices objectAtIndex:index]];
  synth = [[NSSpeechSynthesizer alloc] initWithVoice:voice];
  [voices autorelease];
  [voice autorelease];

  void *context = zmq_ctx_new ();
  void *responder = zmq_socket (context, ZMQ_REP);
  int rc = zmq_bind (responder, argv [1]);
  assert (rc == 0);

  while (1) {
    char *string = s_recv (responder);
    time_t start = time (NULL);
    printf ("recv: %s\n", string);

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
    char *response = (char *) malloc (25 * sizeof(char));
    memset (response, '\0', 25);
    snprintf (response, 25, "%d", (int) elapsed);
    printf ("resp: %s\n", response);
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
