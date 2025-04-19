s.boot;
s.quit;

s.scope;
s.meter;

/*********************************************************************************************/

(
SynthDef(\decay, { arg outBus = 0, effectBus, direct = 0.5, freq = 400;
	var source;
	source = Pan2.ar(Decay2.ar(Impulse.ar(Rand(0.3, 1), 0, 0.125), 0.3, 1,
		SinOsc.ar(SinOsc.kr(0.2, 0, 110, freq))), Rand(-1.0, 1.0));
	Out.ar(outBus, source * direct);
	Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef(\reverb, { arg outBus = 0, inBus;
	var input;
	input = In.ar(inBus, 2);
	16.do({ input = AllpassC.ar(input, 0.04, Rand(0.001, 0.04), 3)});
	Out.ar(outBus, input);
}).add;
)


(
~sources = Group.new;
~effects = Group.after(~sources);
~bus = Bus.audio(s, 2);
)

(
x = Synth(\reverb, [\inBus, ~bus], ~effects);
y = Synth(\decay, [\effectBus, ~bus, \outBus, 0], ~sources);
z = Synth(\decay, [\effectBus, ~bus, \outBus, 0, \freq, 660], ~sources);
)

~sources.free; ~effects.free; ~bus.free;

s.queryAllNodes;

currentEnvironment.clear;
