s.boot;

/**************************************************************************************
- PLAINCHANT 00
- A very rudimentary synth was created, consisting of a sine oscillator with a simple
  envelope that takes, as arguments, the frequency and duration of the tone being
  generated.
- Based on a rough analysis of a plainchant (Great Responsory: Aspiciens a Longe) in
  the Mixolydian authentic mode, the following information was extrapolated:
        1. The range of the chant spans from F4 to A5.
        2. There are 229 notes in total.
        3. Each note within this range was counted, allowing for a second array of
           weights.
        4. The two arrays (note range and weight of each note) were used in a task to
           produce a free-flowing melody comprised of the chant’s notes, played with
           accurate statistical prevalence.
        5. Since rhythm in medieval music was fairly rudimentary, two durations are
           chosen randomly: one whole beat and a half-beat. The beat from the
           TempoClock is converted to seconds and passed as an argument to the Synth.
**************************************************************************************/

(
SynthDef(\tone, { |freq = 440, sus = 1|
	var snd = SinOsc.ar(freq) * Env.linen(0.3, sus, 0.5, curve: \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
~clock = TempoClock.new(100/60);

~t = Task({
	var notes = [65, 67, 69, 71, 72, 74, 76, 77, 79, 81];
	var noteCounts = [2, 13, 20, 15, 42, 55, 42, 30, 8, 2];
	var weight = noteCounts.normalizeSum;
	loop {
		var temp = [0.5, 1].choose;
		var dur = (temp / ~clock.tempo).postln;
		Synth(\tone, [\freq, notes.wchoose(weight).midicps, \sus, max(dur - 0.8, 0.01)]);
		temp.wait;
	}
});
)

~t.play;

