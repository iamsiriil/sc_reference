s.boot;

/**************************************************************************************
- PLAINCHANT 01
**************************************************************************************/

(
SynthDef(\tone, { |freq = 440, sus = 1|
	var snd = SinOsc.ar(freq) * Env.linen(0.3, sus, 0.5, curve: \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
~clock = TempoClock.new(60/60);

~t = Task({
	6.do({

	});
});
)