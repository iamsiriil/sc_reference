s.boot;
s.quit;
s.plotTree;
s.scope;

{ WhiteNoise.ar() }.play;

(
SynthDef(\shaker, {
	var snd;
	snd = WhiteNoise.ar(0.2);
	snd = BPF.ar(snd, 3200);
	snd = snd * Env.perc(0.01, 0.4, curve: \sin).ar(Done.freeSelf);
	//snd = DelayC.ar(snd, 0.3, 0.03 + (LFNoise1.ar(1, 0.3)));
	//snd = LeakDC.ar(snd);
	snd = snd + PitchShift.ar(snd, 1, 2, 0.2);
	snd = Pan2.ar(snd, Rand(-1, 1), Rand(0.2, 0.8));
	Out.ar(0, snd);
}).add;
)

Synth(\shaker)

(
SynthDef(\tone, { |freq = 220|
	var snd = Saw.ar(freq, SinOsc.ar(Rand(2, 100), 0, 5, 10));
	snd = BPF.ar(snd, 1600, 0.3, 0.2);
	snd = snd * Env.perc(0.02, 0.5).ar(Done.freeSelf);
	snd = snd + PitchShift.ar(snd, 0.05, 1, 0.2);
	snd = DelayC.ar(snd, 0.1, 0.01 + (LFNoise2.ar(10, 0.3)));
	snd = Pan2.ar(snd, Rand(-1, 1), Rand(0.2, 0.8));
	Out.ar(0, snd);
}).add;
)

Synth(\tone, [\freq]);

(
~clock = TempoClock.new(100/60);

~t1 = Task({
	var freq = [110, 220, 440, 880, 1600, 3200];
	loop {
		Synth(\tone, [\freq, freq.choose]);
		rrand(0.5, 2).wait;
	}
});

~t2 = Task({
	loop {
		Synth(\shaker);
		[1, 2, 1.5, 0.5].choose.wait;
	}
});
)
(
~t1.play(~clock, quant: 1);
~t2.play(~clock, quant: 1);
)
~t.pause;
