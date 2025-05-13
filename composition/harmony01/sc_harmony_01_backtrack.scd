s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/

// Backtracking function to build the chords
(
~getNextChords = { | currChord, nextChord, validChords, validNotes, i|

	if (i == numVoices && ~chordIsValid.(currChord, nextChord)) {
		validChords.add(nextChord.copy);
	} {
		~toggleRules;
		i = 0;
	};

	// Enforces common tone on the same voice
	if (validNotes[i].size == 1) {
		nextChord[i] = validNotes[i][0];
		~getNextChords.(currChord, nextChord, validChords, validNotes, (i + 1));
	};

	validNotes[i].do({ |n|

		if (i == 0 && ~isRoot.(n) && ~enforceRootPosition == true) {
			nextChord[i] = n;
			~getNextChords.();
		} {
			if (~noteIsValid.(nextChord, n)) {
				~getNextChord.();
			}
		}
	});
};
)