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

/*
-> SynthDef \decay takes four arguments:
   * outBus: the audio bus index for the dry (direct) signal.
   * effectBus: the audio bus index for the wet (effect) signal.
   * direct: dry/wet mix factor (0.5 by default for equal blend).
   * freq: base frequency used for pitch modulation.

-> Impulse.ar(Rand(0.3, 1), 0, 0.125):
   - Generates sporadic impulses, each with a randomly chosen frequency between 0.3 and 1 Hz.
   - This makes the impulses irregular and slightly unpredictable.
   - The `mul` argument (0.125) scales the amplitude of the impulse trigger.

-> Decay2.ar(...):
   - Shapes each impulse into a percussive envelope.
   - Attack time: 0.3 sec, Decay time: 1 sec.
   - The final argument is a modulated audio signal that gets shaped by this envelope.

-> SinOsc.ar(SinOsc.kr(0.2, 0, 110, freq)):
   - Inner SinOsc.kr: a slow LFO oscillating at 0.2 Hz, with amplitude 110, added to `freq` (default 400).
   - This produces a frequency modulation range from 400 - 110 = 290 Hz up to 400 + 110 = 510 Hz, slowly sweeping up and down.
   - Outer SinOsc.ar uses that as its frequency: it's an audible sine wave whose pitch glides slowly, creating a subtle evolving tone.
   - This tone is passed as the audio signal to be enveloped by Decay2.

-> Pan2.ar(..., Rand(-1.0, 1.0)):
   - The enveloped signal is panned randomly in the stereo field with every new Synth trigger.
   - Creates a dispersed, spatial feel.

-> Out.ar(...):
   - Sends the same stereo signal to two destinations:
     * `outBus` gets the signal scaled by `direct` (dry).
     * `effectBus` gets the same signal scaled by (1 - direct) (wet).
   - This ensures that if `direct` is 0.5, you get a 50/50 dry/wet mix; if `direct` is 1.0, 100% dry, etc.
   - **NOTE:** (1 - direct) = 0.5 when direct = 0.5 — *not* negative. The wet signal is just the complementary portion.

*/

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
