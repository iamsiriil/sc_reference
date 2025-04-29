s.boot;
s.quit;
/**************************************************************************************
- HARMONY 00
**************************************************************************************/

(
SynthDef(\sawtone, { |freq = 440, sus = 1|
	var snd = Pulse.ar(freq, 0.1) * Env.linen(0.2, sus, 0.4, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
~rangeIsValid = IdentityDictionary[
	\spn -> { |note| (note >= 60) && (note <= 81) },
	\alt -> { |note| (note >= 55) && (note <= 74) },
	\ten -> { |note| (note >= 48) && (note <= 67) },
	\bas -> { |note| (note >= 40) && (note <= 60) }
];

~checkVoiceCross = { |lowerNote, higherNote| (lowerNote < higherNote) };

~noteIsValid = {
	arg nextChord, i;

	case (
		{ i == 0 }, {
			~rangeIsValid[\bas].(nextChord[i]);
		},
		{ i == 1 }, {
			~rangeIsValid[\ten].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
		},
		{ i == 2 }, {
			~rangeIsValid[\alt].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
		},
		{ i == 3 }, {
			~rangeIsValid[\spn].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
		}
	);

};

~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getNextChord = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid, result;

	if (i == numVoices) {
		validNextChords.add(nextChord.copy);
	} {
		validNotes[i].do { |note|

			nextChord.put(i, note);

			isValid = ~noteIsValid.(nextChord, i);
			if (isValid) {
				~getNextChord.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
			} {
				nextChord.put(i, 0);
			};
		};
		validNextChords;
	};
};

~clock = TempoClock.new(100/60);

~t = { |chordProg|
	Task({
		var noteRange = [40, 43, 48, 52, 55, 60, 64, 67, 72, 76, 79];
		var chords = (
			'c': [40, 43, 48, 52, 55, 60, 64, 67, 72, 76, 79],
			'f': [41, 45, 48, 53, 57, 60, 65, 69, 72, 77, 81],
			'g': [43, 47, 50, 55, 59, 62, 67, 71, 74, 79]
		);

		var currentChord = [48, 55, 64, 72];

		var tempo = 2;
		var duration = tempo / ~clock.tempo;

		chordProg.do { |c, i|
			var validNotes = Array.fill(4, {[]});
			var nextChord = Array.fill(4, {0});
			var validNextChords, buildChord = Array.fill(4, {0});
			var soprano, alto, tenor, bass;
			var root = chords[c][0];


			if (i == 0) {
				nextChord = currentChord;
			} {
				4.do { |j|
					validNotes[j] = ~getValidNotes.(chords[c], currentChord[j]);
				};
				validNextChords = Array.new(10);

				~getNextChord.(currentChord.size, buildChord, validNextChords, validNotes, 0);
				nextChord = validNextChords.choose;
				validNextChords = nil;
			};

			validNotes = nil;

			nextChord.do { |note, voiceIndex|
				Synth(\sawtone, [\freq, note.midicps, \sus, max(duration - 0.4, 0.5)]);
			};
			tempo.wait;

			currentChord = nextChord;
		};
	});
};

~chordProg = ['c', 'f', 'g', 'c', 'f', 'f', 'g', 'c'];
~t.(~chordProg).play(~clock, quant: 1);
)


