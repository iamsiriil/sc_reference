// Pulsar

(
var lfo;

lfo = { |rate|
	Select.ar(ToggleFF.ar(Dust.ar(rate)), [LFNoise2.ar(rate).clip2, TRand.ar(-1, 1, Dust.ar(rate * 3))]);
};

SynthDef(\pulsar, {
	var snd, duration, freq, formantFreq, on;
	duration = \duration.kr(30);
	freq = lfo.(16).linexp(-1, 1, 10, 500);
	formantFreq = lfo.(9).linexp(-1, 1, 100, 8000);
	snd = Phasor.ar(DC.ar(0), freq * SampleDur.ir, 0, 1);
	snd = snd * (formantFreq / freq);
	on = snd <= 1.0;
	snd = (snd * 2pi * lfo.(3).linexp(-1, 1, 1, 2)).cos * on;
	snd = snd.tanh;
	snd = CombC.ar(snd, 0.2, 1 / lfo.(3).linexp(-1, 1, 10, 8000), lfo.(4).linexp(-1, 1, 0.01, 1));
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.13, lfo.(3 ! 2).linexp(-1, 1, 0.5, 2));
	snd = snd * Env.linen(0.001, duration, 0.4, curve: \sin).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\pulsar);

/**********************************************************************************************************/

{ Phasor.ar() }.play;
{ DC.ar() }.play;
{ SampleDur.ar() }.play;
{ CombC.ar() }.play;
{ PitchShift.ar() }.play;
{ Env.ar() }
{ Done }