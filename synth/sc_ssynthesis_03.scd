// Nonlinear multitap delay

s.boot;
s.scope;

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

/*********************************************************************************************************/

(
~bus1 = Bus.audio(s, 1); // Output from stage 1
~bus2 = Bus.audio(s, 1); // Output from stage 2
~bus3 = Bus.audio(s, 7); // Output from multitap delay (7 channels)
~bus4 = Bus.audio(s, 1); // Post pitch shift
~bus5 = Bus.audio(s, 2); // Final stereo output
)

// 1. Source input
(
SynthDef(\stage1_source, {
	var env = EnvGen.kr(Env.perc(0.05, 0.1), doneAction: 2);
	var snd = SinOsc.ar(440) * env;
	Out.ar(~bus1, snd);
	Out.ar(0, snd);
}).add;
)

// 2. Feedback input + high pass filter
(
SynthDef(\stage2_hpf, {
	var in = In.ar(~bus1, 1) + LocalIn.ar(1);
	var filtered = HPF.ar(in, LFNoise2.kr(0.3).linexp(-1, 1, 30, 90));
	Out.ar(~bus2, filtered);
	Out.ar(0, filtered);
	LocalOut.ar(filtered);
}).add; // no sound
)

// 3. Multitap delay
(
SynthDef(\stage3_delay, {
	var in = In.ar(~bus2, 1);
	var taps = DelayC.ar(in, 1.0,
		[0.023, 0.0145, 0.0234, 0.05, 0.34, 0.68, 0.1] +
		(LFNoise2.ar(1 ! 7) * 5e-3)
	);
	Out.ar(~bus3, taps);
	Out.ar(0, taps);
}).add; // no sound
)

// 4. Pitch shift + nonlinearity
(
SynthDef(\stage4_fx, {
	var taps = In.ar(~bus3, 7);
	var shifted = PitchShift.ar(taps * -3.dbamp, 0.013,
		LFNoise2.ar(3 ! taps.size).linexp(-1, 1, 1, 2)
	);
	var merged = taps.sum + shifted;
	var filtered = LPF.ar(merged, LFNoise2.kr(0.3).linexp(-1, 1, 1000, 6000));
	var shaped = filtered * -7.dbamp;
	shaped = shaped.tanh;
	Out.ar(~bus4, shaped);
	Out.ar(0, shaped);
}).add;
)

// 5. Splay + envelope + output
(
SynthDef(\stage5_output, {
	var in = In.ar(~bus4, 1);
	var spread = Splay.ar(in);
	var env = Env.linen(0.001, \duration.kr(30), 0.4, curve: \sin).ar(Done.freeSelf);
	spread = spread * env * -5.dbamp;
	Out.ar(~bus5, spread);
}).add;
)

(
SynthDef(\tapMonitor, {
	var taps = In.ar(~bus3, 7);
	Out.ar(0, Splay.ar(taps));
}).add;
)

~mainGroup = Group.head(s);
~monitorGroup = Group.after(~mainGroup);

(
Synth(\stage1_source, target: ~mainGroup);
Synth(\stage2_hpf, target: ~mainGroup);
Synth(\stage3_delay, target: ~mainGroup);
Synth(\stage4_fx, target: ~mainGroup);
Synth(\stage5_output, target: ~mainGroup);
)

Synth(\tapMonitor, target: ~monitorGroup);
































