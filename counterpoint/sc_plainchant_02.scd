s.boot;

/**************************************************************************************
- PLAINCHANT 02
- A melismatic plainchant simulator inspired by Aspiciens a Longe (Mixolydian, F4–A5).
- Three weighted models: first phrase (D5-heavy), last phrase (G4-biased), middle phrases (averaged).
- Variable phrases (default 3), random lengths (30–40 notes).
- Starts on D5 (MIDI 74), ends on G4 (MIDI 67), avoids tritones (F4→Bb4, Bb4→F5).
**************************************************************************************/

(
SynthDef(\chant, {
	arg freq = 440, atk = 0.1, sus = 0.8, rel = 0.2;
	var snd = SinOsc.ar(freq, SinOsc.ar(5, 0, 0.1));
	snd = snd * Env.linen(atk, sus, rel, curve: \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
~clock = TempoClock.new(100/60);

~t = { |numPhrases = 3|
	Task ({
		var notes = [65, 67, 69, 71, 72, 74, 76, 77, 79, 81];

		var firstPNoteCount = [0, 0, 0, 1, 6, 13, 5, 5, 2, 1];
		var lastPNoteCount = [1, 5, 7, 5, 14, 9, 4, 2, 0, 0];
		var middlePNoteCount = [1, 8, 13, 10, 22, 32, 33, 23, 6, 1];

		var firstPWeights = firstPNoteCount / firstPNoteCount.sum;
		var lastPWeights = lastPNoteCount / lastPNoteCount.sum;
		var middlePWeights = middlePNoteCount / middlePNoteCount.sum;

		var noteDuration = [0.5, 1];
		var currentMidi = 74;

		numPhrases.do { |p|
			var isFirstPhrase = (p == 0);
			var isLastPhrase = (p == (numPhrases - 1));
			var phraseLength = rrand(30, 40);
			var weights = case (
				{ isFirstPhrase }, { firstPWeights },
				{ isLastPhrase }, { lastPWeights },
				{ true }, { middlePWeights }
			);

			phraseLength.do { |n|
				var isLastNote = ((n == (phraseLength - 1)) && isLastPhrase);
				var tempo = noteDuration.choose;
				var dur = tempo / ~clock.tempo;
				var nextMidi;
				var validNotes, validWeights;

				if (isLastNote) {
					validNotes = [67, 69, 65];
					validWeights = validNotes.collect { |n| weights[notes.indexOf(n)] }.normalizeSum;
					nextMidi = validNotes.wchoose(validWeights);
					if (nextMidi != 67) {
						nextMidi = 67;
					};
					dur = 2;
				} {
					validNotes = notes;
					if (currentMidi == 65) {
						validNotes = validNotes.reject { |n| n == 71 };
					};
					if (currentMidi == 71) {
						validNotes = validNotes.reject { |n| n == 77 || n == 65 };
					};
					if (currentMidi == 77) {
						validNotes = validNotes.reject { |n| n == 71 };
					};
					validWeights = validNotes.collect { |n| weights[notes.indexOf(n)] }.normalizeSum;
					nextMidi = validNotes.wchoose(validWeights);
				};

				Synth( \chant, [
					\freq, nextMidi.midicps,
					\atk, 0.1,
					\sus, max(dur - 0.3, 0.01),
					\rel, 0.2
				]);
				currentMidi = nextMidi;
				tempo.wait;
			}
		}

	});
};
)

~t.().play;