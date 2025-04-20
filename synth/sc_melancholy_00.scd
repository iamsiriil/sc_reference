s.boot;

(
SynthDef(\tone, { |freq = 400|
	var modFreq = 220;
	var modIndex = Rand(20, 40);
	var detune = Rand(-0.5, 0.5);
	var mod = SinOsc.ar(modFreq, 0, modIndex);
	var sig = SinOsc.ar((freq + detune) + mod);
	sig = sig * XLine.kr(0.3, 0.01, 5, doneAction: 2);
	sig = FreeVerb.ar(sig, 0.3, 0.8, 0.5);
	sig = Limiter.ar(sig, 0.95);
	sig = sig ! 2;
	Out.ar(0, Pan2.ar(sig, Rand(-1, 1)));
}).add;
)

(
~t = Task({
	var freqs = [48, 52, 54, 55, 59, 60, 64, 66, 67, 71];
	loop {
		Synth(\tone, [\freq, freqs.choose.midicps]);
		[0.5, 1, 1.5, 2].choose.wait;
	}
});
)

(
~clock = TempoClock.new(100/60);

~t.play(~clock);
)
