s.boot;

(
SynthDef(\hihat, {
	var env, snd;
	env = Env.perc(0.01, 0.1, curve: -4).kr(doneAction: 2);
	snd = HPF.ar(WhiteNoise.ar(env), 10000);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\hihat);