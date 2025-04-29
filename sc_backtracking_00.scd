(
~currentChord = [48, 55, 64, 72];
~nextChord = [];
~validNextChord = Array.fill(4, {[]});
~validNotes = [[41, 45, 48, 53], [48, 53, 57, 60], [57, 60, 65, 69], [65, 69, 72, 77]];

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
)

// Gets all valid chords
(
~getNextChords = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid;

	if (i == numVoices) {
		validNextChords.add(nextChord.copy);
	} {
		validNotes[i].do { |note|

			nextChord.put(i, note);

			isValid = ~noteIsValid.(nextChord, i);
			if (isValid) {
				~getNextChords.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
			} {
				nextChord.put(i, 0);
			};
		};
		validNextChords;
	};
};
)

// Gets the first valid chord it finds
(
~getValidChord = Routine({
	arg numVoices, validNotes, i;
	var isValid;

	if (i == numVoices) { // && chordIsValid.(~nextChord)
		^true;
	} {
		validNotes[i].do { |note|

			~nextChord.add(note);

			if (~noteIsValid.(~nextChord, i)) {

				i = i + 1;
				if (~getNextChord.(numVoices, validNotes, i)) {
					^true;
				};
			} {
				~nextChord.removeAt(i);
			};
		};
		^false;
	};
});

if (~getValidChord.(4, ~validNotes, 0)) {
	"Next Chord: %".format(~nextChord);
} {
	"Failed".postln;
};
)

~nextChord.put(0, 2);