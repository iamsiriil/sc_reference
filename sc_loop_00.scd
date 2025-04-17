s.boot;
s.quit;
s.plotTree;

/*********************************************************************/

~path = PathName.new("./../soundbank/drums/".resolveRelative);

~clock = TempoClock.new(60/60);

(
~bufs = ();
~path.entries.do { |folder|
	folder.entries.do { |sfolder|
		~bufs[sfolder.fileNameWithoutDoubleExtension.asSymbol] = Buffer.read(s, sfolder.fullPath);
	};
}
)

(
SynthDef(\drums, {
	arg buff = 0, rate = 1, loop = 0;
	Out.ar(0,
		PlayBuf.ar(2, buff, rate, loop: loop, doneAction: 2) ! 2;
	)
}).add;
)
