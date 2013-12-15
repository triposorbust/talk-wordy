CC = gcc
CCFLAGS = -Wall -I/usr/local/include -L/usr/local/lib
CCLIBS = -lzmq -pthread
OBJFLAGS = -ObjC -framework AppKit

all: sender speaker synth

sender: sender.c sender.h zstring.h
	@ $(CC) $(CCFLAGS) -o $@ $< $(CCLIBS)

speaker: speaker.c zstring.h
	@ $(CC) $(CCFLAGS) -o $@ $< $(CCLIBS)

synth: synthesizer.m
	@ $(CC) $(OBJFLAGS) -o $@ $<

.PHONY: clean
clean:
	@ rm -f sender speaker synth
