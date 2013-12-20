CC = gcc
CCFLAGS = -Wall -I/usr/local/include -L/usr/local/lib -lzmq
OBJFLAGS = -ObjC -framework AppKit -lzmq

all: sender speaker synth subprocess

sender: sender.c sender.h zstring.h
	@ $(CC) $(CCFLAGS) -o $@ $<

speaker: speaker.c zstring.h
	@ $(CC) $(CCFLAGS) -o $@ $<

synth: synthesizer.m
	@ $(CC) $(OBJFLAGS) -o $@ $<

subprocess: subprocess.c
	@ $(CC) $(CCFLAGS) -o $@ $<

.PHONY: clean
clean:
	@ rm -f sender speaker synth subprocess *.ipc
