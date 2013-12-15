#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main (int argc, char **argv)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];

  int word;
  for (word=1; word<argc; ++word) {
    NSString *wrapped = [NSString stringWithUTF8String:argv[word]];
    [synth startSpeakingString:wrapped];
    while ([synth isSpeaking])
      [NSThread sleepForTimeInterval:0.1];
    [wrapped autorelease];
  }

  [synth autorelease];

  [NSThread sleepForTimeInterval:0.2];
  [pool release];
  return 0;
}
