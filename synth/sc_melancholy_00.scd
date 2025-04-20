s.boot;
s.quit;

(
~bufs = ();
~path = PathName.new("./../../soundbank/drums/".resolveRelative);
Buffer.read(s, ~path.entries[2].entries[2].fullPath, action: { |buf|
	~bufs[\kd] = buf;
});
Buffer.read(s, ~path.entries[0].entries[0].fullPath, action: { |buf|
	~bufs[\cl] = buf;
});

SynthDef(\drums, { |bufnum = 0|
	var pbuf = PlayBuf.ar(2, bufnum);
	Out.ar(0, pbuf);
}).add;
)

Buffer.freeAll;

(
SynthDef(\tone, { |freq = 400|
	var modFreq = 220;
	var modIndex = Rand(20, 40);
	var detune = Rand(-0.5, 0.5);
	var mod = SinOsc.ar(modFreq, 0, modIndex);
	var sig = SinOsc.ar((freq + detune) + mod);
	sig = sig * XLine.kr(0.3, 0.01, 5, doneAction: 2);
	sig = FreeVerb.ar(sig, 0.3, 0.8, 0.5);
	sig = Limiter.ar(sig, 0.95);
	sig = sig ! 2;
	Out.ar(0, Pan2.ar(sig, Rand(-1, 1)));
}).add;
)

(
~t_harm = Task({
	var freqs = [48, 52, 54, 55, 59, 60, 64, 66, 67, 71];
	loop {
		Synth(\tone, [\freq, freqs.choose.midicps]);
		[0.5, 1, 1.5, 2].choose.wait;
	}
});
)

(
~t_drum = Task({
	loop {
		Synth(\drums, [\bufnum, ~bufs[\kd].bufnum]);
		1.5.wait;
		Synth(\drums, [\bufnum, ~bufs[\kd].bufnum]);
		0.5.wait;
		Synth(\drums, [\bufnum, ~bufs[\cl].bufnum]);
		2.wait;
	}
});
)

(
~clock = TempoClock.new(100/60);

~t_harm.play(~clock, quant: 1);
~t_drum.play(~clock, quant: 1);
)
