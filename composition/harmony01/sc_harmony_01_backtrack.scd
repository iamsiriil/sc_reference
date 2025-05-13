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
		~resetRules;
	} {
		~toggleRules;
		i = 0;
	};

	// Enforces common tone on the same voice
	if ((i > 0) && (~enforceCommonTone == true) && (validChord[i].size == 1)) {
		nextChord[i] = validChord[i][0][0];
		~getNextChords.();
	}


	validNotes[i].do({ |n|

		case
		{ (i == 0) && (~enforceRootPosition == true) && (n[1] == "Rt") } {
			nextChord[i] = n[0];
			~getNextChord.();
		}
		{ (i == 0) && (~enforceFirstInversion == true) && (n[1].contains("3")) } {
			nextChord[i] = n[0];
			~getNextChord.();
		}
		{ (i == 0) && (~enforceFirstInversion == true) && (n[1].contains("5")) } {
			nextChord[i] = n[0];
			~getNextChord.();
		}
		{
			nextChord[i] = n[0];
		};

		if (i > 0 && ~checkVocalRange.(nextChord, n[0], i)) {
			~getNextChord.();
		} {
			nextChord[i] = 0;
		};

	});
};
)