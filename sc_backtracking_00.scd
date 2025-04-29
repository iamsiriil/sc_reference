
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
~getValidChord = Routine {
	arg numVoices, nextchord, validNotes;
	var isValid;

	if (i == numVoices) { // && chordIsValid.(~nextChord)
		^true;
	} {
		validNotes[i].do { |note|

			nextChord.put(i, note);

			isValid = ~noteIsValid.(nextChord, i);
			if (isValid) {

				if (~getNextChord.(numVoices, nextChord, validNextChords, validNotes, (i + 1))) {
					^true;
				} {
					nextChord.put(i, 0);
				}
			}
		};
		^false;
	};
};
)