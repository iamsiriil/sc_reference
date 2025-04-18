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
SynthDef(\drums, {
	arg buff = 0, rate = 1, loop = 0;
	Out.ar(0,
		PlayBuf.ar(2, buff, rate, loop: loop, doneAction: 2) ! 2;
	)
}).add;
)

Buffer.freeAll;

~x = Synth(\drums, [\buff, ~bufs[\sd_00].bufnum, \loop, 1]);
~x.free;


(
~makeKick = {
	Routine {
		loop {
			Synth(\drums, [\buff, ~bufs[\kd_01].bufnum]);
			2.5.wait;
			Synth(\drums, [\buff, ~bufs[\kd_01].bufnum]);
			1.5.wait;
		}
	}
};
)

(
~makeHat = {
	Routine {
		loop {
			1.wait;
			Synth(\drums, [\buff, ~bufs[\hh_00].bufnum]);
			2.wait;
			Synth(\drums, [\buff, ~bufs[\hh_00].bufnum]);
			1.wait;
		}
	}
};
)

(
~makeSnr = {
	Routine {
		loop {
			0.5.wait;
			Synth(\drums, [\buff, ~bufs[\sd_00].bufnum]);
			0.5.wait;
		}
	}
};
)


(
~kick = ~makeKick.();
~hat  = ~makeHat.();
~snr  = ~makeSnr.();
)

(
~clock = TempoClock.new(180/60);

~kick.play(~clock, quant: 4);
~hat.play(~clock, quant: 4);
~snr.play(~clock, quant: 2);
)















