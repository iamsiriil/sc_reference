(
~rangeIsValid = IdentityDictionary[
	\spn -> { |note| (note >= 60) && (note <= 81) }, // C4-A5
	\alt -> { |note| (note >= 55) && (note <= 74) }, // G3-D5
	\ten -> { |note| (note >= 48) && (note <= 67) }, // C3-G4
	\bas -> { |note| (note >= 40) && (note <= 60) }  // E2-C4
];

~checkVoiceCross = { |lowerNote, higherNote| (lowerNote < higherNote) };

~noteIsValid = {
	arg nextChord, i;

	case
	{ i == 0 } {
		~rangeIsValid[\bas].(nextChord[i]);
	}
	{ i == 1 } {
		~rangeIsValid[\ten].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
	}
	{ i == 2 } {
		~rangeIsValid[\alt].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
	}
	{ i == 3 } {
		~rangeIsValid[\spn].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
	};
};

// Gets all valid chords
~getNextChords = {
	arg numVoices, nextChord, validNextChords, validNotes, i;

	if (i == numVoices) {
		validNextChords.add(nextChord.copy);
	} {
		validNotes[i].do { |note|

			nextChord.put(i, note);

			if (~noteIsValid.(nextChord, i)) {
				~getNextChords.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
			} {
				nextChord.put(i, 0);
			};
		};
		if (validNextChords[0].notNil) { true } { false };
	};
};
)

// Test Function
(
var nextChord = Array.fill(4, {0});
var validNextChords = List.fill(0, {nil});
var validNotes = [[41, 45, 48, 53], [48, 53, 57, 60], [57, 60, 65, 69], [65, 69, 72, 77]];

~getNextChords.(4, nextChord, validNextChords, validNotes, 0);

"Valid Next Chords: %\nsize: %".format(validNextChords, validNextChords.size).postln;
)
