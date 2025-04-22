// Short feedback

s.boot;

(
var lfo;

lfo = { |rate|
	Select.ar(ToggleFF.ar(Dust.ar(rate)), [LFNoise2.ar(rate).clip2, TRand.ar(-1, 1, Dust.ar(rate * 3))]);
};

SynthDef(\fb, {
	var snd, duration;
	duration = \duration.kr(3);
	snd = Hasher.ar(Sweep.ar) * Env.perc(0.001, 0.03).ar;
	snd = snd + LocalIn.ar(2);
	snd = DelayC.ar(snd, 0.2, lfo.(XLine.ar(10, 30, duration)).linlin(-1, 1, 0.0, 0.01) + (lfo.(16 ! 2).linlin(-1, 1, 0.0, 0.001)));
	snd = LeakDC.ar(snd);
	snd = snd + (snd.reverse * -10.dbamp);
	snd = snd + PitchShift.ar(snd.reverse * -3.dbamp, 0.01, 2 ** lfo.(1 ! 2));
	snd = BHiShelf.ar(snd, 8120, 0.3, -3);
	snd = snd * lfo.(3).linexp(0, 1, 1, 10.dbamp);
	snd = snd.clip2;
	LocalOut.ar(snd);
	snd = BRF.ar(snd, lfo.(3).linexp(-1, 1, 100, 500), 0.1);
	snd = snd + DelayC.ar(snd.reverse * -13.dbamp, 0.2, [10e-3, 14e-3]);
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\fb);

