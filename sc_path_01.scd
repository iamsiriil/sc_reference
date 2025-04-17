s.boot;
s.quit;
s.plotTree;

/*********************************************************************/

~path = PathName.new("./../soundbank/drums/".resolveRelative);

(
~bufs = ();
~path.entries.do { |folder|
	folder.entries.do { |sfolder|
		~bufs[sfolder.fileNameWithoutDoubleExtension.asSymbol] = Buffer.read(s, sfolder.fullPath);
	};
}
)

(
SynthDef(\playBuffer, {
	arg buff = 0, rate = 1, loop = 0;
	var sig;
	sig = PlayBuf.ar(2, buff, rate, loop: loop, doneAction: 2);
	sig = sig ! 2;
	Out.ar(0, sig);
}).add;
)

(
~clock = TempoClock.new(120/60);

~loopRoutine = Routine({
	loop {
		Synth(\playBuffer, [\buff, ~bufs[\kd_01].bufnum]);
		1.wait;
		Synth(\playBuffer, [\buff, ~bufs[\hh_00].bufnum]);
		0.5.wait;
		Synth(\playBuffer, [\buff, ~bufs[\kd_01].bufnum]);
		1.wait;
		Synth(\playBuffer, [\buff, ~bufs[\hh_00].bufnum]);
		1.5.wait;
	}
}).play(~clock);
)

Buffer.freeAll;
