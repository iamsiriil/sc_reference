s.boot;


/**************************************************************************************
- PLAINCHANT 01
- Melismatic chant simulator inspired by Aspiciens a Longe (Mixolydian, F4–A5, 229 notes).
- Features three weighted models: first phrase (D5-heavy, 33 notes), last phrase (C5-heavy,
  47 notes, G4 end), middle phrases (E5/D5-heavy, 149 notes). Starts on D5, uses sine wave
  SynthDef, 60 BPM, random phrase lengths [33, 47, 31, 43, 45, 30].
**************************************************************************************/

(
SynthDef(\tone, { |freq = 440, sus = 1|
	var snd = SinOsc.ar(freq) * Env.linen(0.3, sus, 0.5, curve: \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

Synth(\tone)

(
~clock = TempoClock.new(60/60);

~t = { |numPhrases = 6|
	Task({
		var firstPNotes = [71, 72, 74, 76, 77, 79, 81];
		var firstPNoteCount = [1, 6, 13, 5, 5, 2, 1];
		var firstPWeights = firstPNoteCount / firstPNoteCount.sum;

		var lastPNotes = [65, 67, 69, 71, 72, 74, 76, 77];
		var lastPNoteCount = [1, 5, 7, 5, 14, 9, 4, 2];
		var lastPWeights = lastPNoteCount / lastPNoteCount.sum;

		var middlePNotes = [65, 67, 69, 71, 72, 74, 76, 77, 79, 81];
		var middlePNoteCount = [1, 8, 13, 10, 22, 32, 33, 23, 6, 1];
		var middlePWeights = middlePNoteCount / middlePNoteCount.sum;

		var notesPerPhrase = [33, 47, 31, 43, 45, 30];
		var noteDurations = [1, 0.5];

		numPhrases.do({ |p|
			case
			{ p == 0 } {
				"First phrase".postln;
				notesPerPhrase.choose.do {
					var tempo = noteDurations.choose;
					var dur = tempo / ~clock.tempo;
					Synth(\tone, [\freq, firstPNotes.wchoose(firstPWeights).midicps, \sus, max(dur - 0.8)]);
					tempo.wait;
				}
			}
			{ p == (numPhrases - 1) } {
				var n = notesPerPhrase.choose;
				"Last phrase".postln;
				n.do { |i|
					if ( i == (n - 1) ) {
						Synth(\tone, [\freq, 67.midicps, \sus, (2 - 0.8)]);
					} {
						var tempo = noteDurations.choose;
						var dur = tempo / ~clock.tempo;
						Synth(\tone, [\freq, lastPNotes.wchoose(lastPWeights).midicps, \sus, max(dur - 0.8)]);
						tempo.wait;
					}

				}
			}
			{
				"Middle phrase".postln;
				notesPerPhrase.choose.do {
					var tempo = noteDurations.choose;
					var dur = tempo / ~clock.tempo;
					Synth(\tone, [\freq, middlePNotes.wchoose(middlePWeights).midicps, \sus, max(dur - 0.8)]);
					tempo.wait;
				}
			}
		});
	});
};
)

~t.(3).play;
