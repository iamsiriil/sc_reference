s.boot;

(
SynthDef(\snare, {
	var env, noise, tone, snd;
	env = Env.perc(0.01, 0.2, curve: -4).kr(doneAction: 2);
	noise = WhiteNoise.ar(mul: env * 0.4);
	tone = SinOsc.ar(180 * (env ** 2) + 50, mul: env * 0.3);
	snd = noise + tone;
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\snare);