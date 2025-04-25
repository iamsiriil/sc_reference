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
				notesPerPhrase.choose.do {
					var tempo = noteDurations.choose;
					var dur = tempo / ~clock.tempo;
					Synth(\tone, [\freq, firstPNotes.wchoose(firstPWeights).midicps, \sus, (dur - 0.8)]);
					tempo.wait;
				}
			}
			{ p == (numPhrases - 1) } {
				notesPerPhrase.choose.do {
					var tempo = noteDurations.choose;
					var dur = tempo / ~clock.tempo;
					Synth(\tone, [\freq, lastPNotes.wchoose(lastPWeights).midicps, \sus, (dur - 0.8)]);
					tempo.wait;
				}
			}
			{
				notesPerPhrase.choose.do {
					var tempo = noteDurations.choose;
					var dur = tempo / ~clock.tempo;
					Synth(\tone, [\freq, middlePNotes.wchoose(middlePWeights).midicps, \sus, (dur - 0.8)]);
					tempo.wait;
				}
			}
		});
	});
};
)

~t.().play;

~firstPNoteCount = [1, 6, 13, 5, 5, 2, 1].sum;

~lastPNoteCount = [1, 5, 7, 5, 14, 9, 4, 2].sum;

~middlePNoteCount = [1, 8, 13, 10, 22, 32, 33, 23, 6, 1].sum + 47 + 33;