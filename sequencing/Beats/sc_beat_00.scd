(
SynthDef(\tone, { |freq, dur|
	var env, snd, lin;
	env = EnvGen.ar(Env.perc(0.01, dur, curve: 0), doneActioon: 2);
	lin = Line.ar(230, 1600, dur, doneAction: 2);
	snd = Saw.ar(freq) * env;
	snd = LPF.ar(snd, lin, 0.5) * 0.5;
	snd = snd ! 2;
	Out.ar(0, snd);
}).add;
)

Synth(\tone);

(
~clock = TempoClock.new(120/60);

Ppar([
	Pbind(
		\instrument, \kick,
		\dur, Pseq([1, Rest(), 1, Rest()], inf),
	),
	Pbind(
		\instrument, \hihat,
		\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], inf)
	),
	Pbind(
		\instrument, \snare,
		\dur, Pseq([Rest(), 1, Rest(), 1], inf)
	),
	Pbind(
		\instrument, \tone,
		\freq, 220,
		\dur, Pseq([1, Rest(5)], inf)
	)
]).play(~clock);

)