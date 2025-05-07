s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 /
**************************************************************************************/

(
~chordState = (
	\currChord,
	\nextChord,
	\validNotes,
	\collectValidChords
);

~chordIsValid = { |currentChord, nextChord|

};

~count = 0;
~toggleRules = {
	switch (~count)
	{ 0 } { ~enforceRootPosition == false }
	{ 1 } { ~enforceDuplicateRoot == false }
	{ 2 } {
		~enforceParallelFifths == false;
		~enforceParallelOctave == false;
	}
	~count = ~count + 1;
};

~resetRules = {
	if (~enforceRootPosition == false)   { ~enforceRootPosition == true };
	if (~enforceRootDuplicat == false)   { ~enforceRootDuplicat == true };
	if (~enforceParallelFifths == false) { ~enforceParallelFifths == true };
	if (~enforceParallelOctave == false) { ~enforceParallelOctave == true };
};

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