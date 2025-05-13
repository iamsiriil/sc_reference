s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/

// validNotes = [ [[12, "Rt"], [45, "m3"]], [[...], [...]], [[...], [...]], [[...], [...]] ];

// Backtracking function to build the chords
(
~getNextChords = { | currChord, nextChord, validChords, validNotes, i|

	if (i == numVoices && ~chordIsValid.(currChord, nextChord, numVoices)) {
		validChords.add(nextChord.copy);
	} {
		~toggleRules;
		i = 0;
	};

	// Enforces common tone on the same voice
	if (~enforceRootPosition == true) {
		if ((i > 0) && (validNotes[i].size == 1)) {
			nextChord[i] = validNotes[i][0][0];
			~getNextChords.(currChord, nextChord, validChords, validNotes, (i + 1));
		};
	} {
		if (validNotes[i].size == 1) {
			nextChord[i] = validNotes[i][0][0];
			~getNextChords.(currChord, nextChord, validChords, validNotes, (i + 1));
		};
	}

	validNotes[i].do({ |n|

		if ((i == 0) && (n[1] == "Rt") && (~enforceRootPosition == true)) {
			nextChord[i] = n[0];
			~getNextChords.();
		} {
			if (~checkVocalRange.(nextChord, n, i)) {
				~getNextChord.();
			}
		}
	});
};
)