// Nonlinear multitap delay

(
SynthDef(\multitap, {
	var snd, duration;
	duration = \duration.kr(30);
	snd = SinOsc.ar(440) * Env.perc(0.05, 0.1).ar;
	snd = snd + LocalIn.ar(1);
	snd = HPF.ar(snd, LFNoise2.ar(0.3).linexp(-1, 1, 30, 90));
	snd = DelayC.ar(snd, 1.0, [0.023, 0.0145, 0.0234, 0.05, 0.34, 0.68, 0.1] + (LFNoise2.ar(1 ! 7) * 5e-3));
	snd = LeakDC.ar(snd);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.013, LFNoise2.ar(3 ! snd.size).linexp(-1, 1, 1, 2));
	snd = LPF.ar(snd, LFNoise2.ar(0.3).linexp(-1, 1, 1000, 6000));
	snd = snd * -7.dbamp;
	snd = snd.tanh;
	LocalOut.ar(snd.sum);
	snd = Splay.ar(snd);
	snd = snd * Env.linen(0.001, duration, 0.4, curve: \sin).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\multitap);