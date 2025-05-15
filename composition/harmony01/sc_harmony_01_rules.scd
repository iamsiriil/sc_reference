s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Rule Enforcement and Tests
**************************************************************************************/
// Flags
(
~enforceVoiceCrossProhibition = true;  // Enforced in function ~checkVoiceRange, during backtrack
~enforceMelodicIntervals      = true;
~enforceVocalRange            = true;  // Enforced in function ~getValidNotes, before backtrack

~enforceParallelOctaves       = true;  // Enforced in function ~chordIsValid, during backtrack
~enforceParallelFifths        = true;  // Enforced in function ~chordIsValid, during backtrack

~enforceNoteDuplicate         = true;  // Enforced in function ~chordIsValid, during backtrack

// Note duplication enforcement flags: 1 true to 2 false
~enforceRootDuplicate         = true;  // Enforced in function ~checkNoteDuplicate, during backtrack
~enforceThirdDuplicate        = false; // Enforced in function ~checkNoteDuplicate, during backtrack
~enforceFifthDuplicate        = false; // Enforced in function ~checkNoteDuplicate, during backtrack

~enforceRootPosition          = true;  // Enforced in function ~getNextChords, during backtrack
~enforceFirstInversion        = false; // Enforced in function ~getNextChords, during backtrack
~enforceSecondInversion       = false; // Enforced in function ~getNextChords, during backtrack

~enforceCommonTones           = true;  // Enforced in function ~getValidNotes, before backtrack
)

/*************************************************************************************/
// Check range between voices
(
~checkVoiceSpacing = { |nextChord, i|
	var cross, n;

	if (i > 0) {
		n = (nextChord[i] - nextChord[i - 1]);

		cross = if (~enforceVoiceCrossProhibition == true) {
			(n >= 0);
		} {
			(n >= -4);
		};

		switch(i)
		{ 1 } { cross && (n <= 24) }
		{ 2 } { cross && (n <= 12) }
		{ 3 } { cross && (n <= 12) }
	} {
		true;
	};
};
)

/*************************************************************************************/
// Check for parallel octaves
(
~checkParallelOctaves = { |nextChord|
	var currChord = ~chordState[\currChord];
	var numVoices = ~voiceData[\numVoices];
	var index, result;
	var octaves = [12, 24, 36];

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
~checkParallelFifths = { |nextChord|
	var currChord = ~chordState[\currChord];
	var numVoices = ~voiceData[\numVoices];
	var index = Array.new(4), result = false;
	var fifths = [7, 19, 31, 43];

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
	var degrees, chordAsSet, degreesAsSet;
	var cipher = ~chordState[\nextCipher];

	degrees = ~getChordNotesDegree.(nextChord).postln;

	degreesAsSet = ~chordData[\chords][cipher][\degree].asSet;
	chordAsSet = degrees.asSet;

	if (chordAsSet == degreesAsSet) {
		case
		{ ~enforceRootDuplicate == true } {
			(degrees.count({ |item| item == "Rt" }) == 2);
		}
		{ ~enforceThirdDuplicate == true } {
			(degrees.count({ |item| item.contains("3") }) == 2);
		}
		{ ~enforceFifthDuplicate == true } {
			(degrees.count({ |item| item.contains("5") }) == 2);
		}
	} {
		false;
	};
};
~enforceRootDuplicate = false;
~enforceThirdDuplicate = false;
~enforceFifthDuplicate = true;

~nextChord = [48, 55, 67, 72];
~chordState[\nextCipher] = 'CM';
~chordData[\chordProg] = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 2]];
~getChordDegreeArrays.();
~checkNoteDuplicate.(~nextChord);
)
~chordData[\chords][\CM][\degree]
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
	~enforceMelodicIntervals      = true;
	~enforceVocalRange            = true;
	~enforceParallelOctaves       = true;
	~enforceParallelFifths        = true;
	~enforceNoteDuplicate         = true;
	~enforceRootDuplicate         = true;
	~enforceThirdDuplicate        = false;
	~enforceFifthDuplicate        = false;
	~enforceRootPosition          = true;
	~enforceFirstInversion        = false;
	~enforceSecondInversion       = false;
	~enforceCommonTone            = true;

	~toggleCount = 0;
	nil;
};
)
