s.boot;

(
SynthDef(\kick, {
	var env, snd;
	env = Env.perc(0.01, 0.2, 1, -4).kr(doneAction: 2);
	snd = SinOsc.ar(20 + (env * 200), mul: env * 0.5);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\kick);