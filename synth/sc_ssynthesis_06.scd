(
SynthDef(\slide, {
	arg bfreq = 1, tfreq = 1000, dur = 0.8;
	var snd = LFTri.ar(Line.ar(bfreq, tfreq), mul: 0.2);
	snd = BPF.ar(snd, 80, mul: 0.8);
	snd = PitchShift.ar(snd, 0.1, 4, 0.8);
	snd = snd + LFNoise2.ar(400, 0.3);
	snd = DelayC.ar(snd, 0.2, 0.1, 0.6);
	snd = FreeVerb.ar(snd, 0.5, 0.9, 0.2, 0.8);
	snd = snd * Env.perc(0.5, dur, curve: \sin).ar(Done.freeSelf);
	snd = Pan2.ar(snd, Rand(-1, 1));
	Out.ar(0, snd);
}).add;
)

Synth(\slide)

(
~t = Task({
	var bassFreq = [1, 5, 10, 50, 100, 200, 500];
	var topFreq = [600, 700, 800, 900, 1000, 1100, 1200];
	loop {
		Synth(\slide, [\bfreq, bassFreq.choose, \tfreq, topFreq.choose, \dur, rrand(1, 2.5)]);
		rrand(0.25, 1.5).wait;
	}
}).play;
)