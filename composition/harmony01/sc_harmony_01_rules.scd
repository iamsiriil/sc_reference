s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Rule Enforcement and Tests
**************************************************************************************/

// Flags
(
~enforceVoiceCrossProhibition = true;  // Enforced in function ~checkVoiceRange, during backtrack
~enforceVocalRange            = true;  // Enforced in function ~getValidNotes, before backtrack

~enforceParallelOctaves       = true;  // Enforced in function ~chordIsValid, during backtrack
~enforceParallelFifths        = true;  // Enforced in function ~chordIsValid, during backtrack

~enforceNoteDuplicate         = true;  // Enforced in function ~chordIsValid, during backtrack

// Note duplication enforcement flags: 1 true to 2 false
~enforceRootDuplicate         = true;  // Enforced in function ~checkNoteDuplicate, during backtrack
~enforceThirdDuplicate        = false; // Enforced in function ~checkNoteDuplicate, during backtrack
~enforceFifthDuplicate        = false; // Enforced in function ~checkNoteDuplicate, during backtrack

~enforceCommonTone            = true;  // Enforced in function ~getValidNotes, before backtrack
)

/*************************************************************************************/
// Check range between voices
(
~checkVoiceRange = { |nextChord, note, i|
	var cross, voice, n;

	if (i > 0) {
		voice = ~voiceData[\voiceNames][i];
		n = (nextChord[i] - nextChord[i - 1]);

		cross = if (~enforceVoiceCrossProhibition == true) {
			(n >= 0);
		} {
			(n < 0) && (nextChord[i] >= ~voiceData[\voiceRange][voice][0]);
		};

		switch(i)
		{ 1 } { cross && (n <= 24) }
		{ 2 } { cross && (n <= 12) }
		{ 3 } { cross && (n <= 12) }
	} {
		true
	}
};
)

/*************************************************************************************/
// Check for parallel octaves
(
~checkParallelOctaves = { |currChord, nextChord, numVoices|
	var index, result;
	var octaves = [12, 24, 36, 48, 60];

	var i = 0, j;
	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			octaves.do { |oct|
				if ((currChord[j] - currChord[i]) == oct) { index = [i, j] };
			};
			j = j + 1;
		};
		i = i + 1;
	};
	result = (
		(currChord[index[1]] - currChord[index[0]]) ==
		(nextChord[index[1]] - nextChord[index[0]])
	);
	result.not;
};
)

/*************************************************************************************/
// Check for parallel fifths
(
~checkParallelFifths = { |currChord, nextChord, numVoices|
	var index = Array.new(4), result = false;
	var fifths = [7, 19, 31, 43, 55];

	var i = 0, j;
	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			fifths.do { |n|
				if ((currChord[j] - currChord[i]) == n) { index.add([i, j]) };
			};
			j = j + 1;
		};
		i = i + 1;
	};
	index.do { |i|
		result = result ||
		((currChord[i[1]] - currChord[i[0]]) ==
		(nextChord[i[1]] - nextChord[i[0]]));
	};
	result.not;
};
)

/*************************************************************************************/
// Check root duplication
(
~checkNoteDuplicate = { |nextChord|
	var chord, chordDegree, numRoot;

	chord = ~chordData[\chords][~chordData[\nextHarmony]];
	chordDegree = chord.select({ |item|
		(item[0] == nextChord[0]) ||
		(item[0] == nextChord[1]) ||
		(item[0] == nextChord[2]) ||
		(item[0] == nextChord[3])
	});

	ocase
	{ ~enforceRootDuplicate == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 2)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 1) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 1)
	}
	{ ~enforceThirdDuplicate == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 1)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 2) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 1)
	}
	{ ~enforceFifthDuplicate == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 1)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 1) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 2)
	}
};
)

/*************************************************************************************/
// Final check8 before chord gets added to validNextChord array
(
~chordIsValid = { |currChord, nextChord, numVoices|
	(
		(
			if (~enforceNoteDuplicate == true) {
				~checkNoteDuplicate.(nextChord)
			} { true }
		) &&
		(
			if (~enforceParallelOctaves == true) {
				~checkParallelOctaves.(currChord, nextChord, numVoices)
			} { true }
		) &&
		(
			if (~enforceParallelFifths == true) {
				~checkParallelFifths.(currChord, nextChord, numVoices)
			} { true }
		)
	)
};
)

/*************************************************************************************/
// Toggle rules
(
~toggleCount = 0;

~toggleRules = { |count|
	switch (count)
	{ 0 } {}
	{ 1 } {}
	{ 2 } {}
	{ 3 }
};
)

/*************************************************************************************/
// Reset rules
(
~resetRules = {
	~enforceVoiceCrossProhibition = true;
	~enforceParallelOctaves       = true;
	~enforceParallelFifths        = true;
	~enforceNoteDuplicate         = true;
	~enforceRootDuplicate         = true;
	~enforceThirdDuplicate        = false;
	~enforceFifthDuplicate        = false;
	~enforceCommonTone            = true;
};
)
