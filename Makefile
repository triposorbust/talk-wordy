CC = gcc
CCFLAGS = -Wall -I/usr/local/include -L/usr/local/lib
CCLIBS = -lzmq -pthread

all: sender speaker

sender: sender.c sender.h zstring.h
	@ $(CC) $(CCFLAGS) -o $@ $< $(CCLIBS)

speaker: speaker.c zstring.h
	@ $(CC) $(CCFLAGS) -o $@ $< $(CCLIBS)

.PHONY: clean
clean:
	@ rm -f sender speaker
