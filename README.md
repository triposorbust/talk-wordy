Wordy Talk
==========

Remote Speech Synthesis
-----------------------

If no one else will, at least you can make your computer talk wordy to you! A way to remotely control the speech synthesizer on a Mac.


Quickstart
----------

The default target produces the binaries `sender` and `speaker`. `synth` is an auxiliary binary that exists as a forked process under `speaker`. To build all three, use: `make`.

```
% make
```

You can now run the `speaker` as a background process on a port of your choice, and use the `sender` to send text.


Dependencies
------------

 - Cocoa AppKit (used for NSSpeechSynthesizer) + Foundation
 - ZeroMQ (>= 4.0.0)
 - GCC + GNU make


Notes
-----

As WLCF points out, this could be also be done by attaching the OSX `say` command to a particular network port (i.e. with `-n` option).

Or a subshell / subprocess (`fork`) call.


Authors
-------

 - Andy Chiang
 - ...


License
-------

Distributed under The MIT License. Copyright &copy; Andy Chiang 2013.