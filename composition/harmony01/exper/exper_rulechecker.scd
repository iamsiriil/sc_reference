// Test fixtures
(
// Test parallel octaves
~currChordPO = [[41, 53, 60, 69], [41, 57, 65, 72], [41, 57, 60, 65], [43, 52, 64, 71], [43, 52, 59, 64], [40, 55, 60, 72]];
~nextChordPO = [[48, 60, 64, 67], [48, 55, 72, 76], [48, 55, 64, 72], [40, 55, 67, 72], [48, 55, 64, 67], [48, 57, 65, 77]];
~nextChordPOValid =[[48, 52, 60, 67], [48, 55, 64, 72], [48, 55, 60, 64], [48, 55, 64, 72], [48, 55, 60, 64], [41, 53, 60, 69]];
~octavesAt     = [[[0, 1], true]  , [[0, 2], true]  , [[0, 3], true]  , [[1, 2], true]  , [[1, 3], true]  , [[2, 3], true] ];

// Test parallel fifths
~currChordPF = [[48, 55, 64, 72], [41, 53, 60, 69], [41, 57, 65, 72], [43, 55, 62, 71], [43, 52, 64, 71], [53, 55, 64, 71]];
~nextChordPF = [[50, 57, 62, 65], [48, 55, 67, 76], [46, 62, 70, 77], [48, 57, 64, 69], [43, 55, 59, 74], [53, 57, 65, 72]];
~nextChordPFValid =[[]];
//~fifthsAt

~chordData = Dictionary[
	\chords -> Dictionary[
		\Cm -> OrderedIdentitySet[[0, "Rt"], [3, "m3"], [7, "P5"], [12, "Rt"], [15, "m3"], [19, "P5"], [24, "Rt"], [27, "m3"], [31, "P5"], [36, "Rt"], [39, "m3"], [43, "P5"], [48, "Rt"], [51, "m3"], [55, "P5"], [60, "Rt"], [63, "m3"], [67, "P5"], [72, "Rt"], [75, "m3"], [79, "P5"], [84, "Rt"], [87, "m3"], [91, "P5"], [96, "Rt"], [99, "m3"], [103, "P5"], [108, "m3"], [111, "P5"], [115, "Rt"], [120, "m3"], [123, "P5"], [127, "Rt"]]
	],
	\progretion -> ['Cm'],
	\nextHarmony -> 'Cm'
];

~enforceRootDuplicat = true;
~nextChordRD = [48, 60, 63, 67]; // Duplicate root
~nextChord3D = [48, 63, 67, 75]; // Duplicate third
~nextChord5D = [48, 55, 63, 67]; // Duplicate fifth
)

~chordData[\nextHarmony]

67-48
/*************************************************************************************************************************/
// Check range between voices
// I can test voice crossing by enforcing a lower bound: 0 no voice crossing; < 0 voice crossing
(
~checkRange = { |nextChord, i|
	if (i == 1) {
		(nextChord[i] - nextChord[i - 1]) <= 24;
	};
	if ((i == 2) && (i == 3)) {
		(nextChord[i] - nextChord[i - 1]) <= 12;
	};
};
~checkRange.(~nextChord[0], 2);
)

/*************************************************************************************************************************/
// Check for parallel octaves
(
~checkParallelOct = { |currChord, nextChord, numVoices|
	var index;
	var octaves = [12, 24, 36, 48, 60];

	for (0, (numVoices - 2)) { |i|

		for (1, (numVoices - 1)) { |j|

			octaves.do { |oct|
				if ((currChord[j] - currChord[i]) == oct) { index = [i, j] };
			};
		};
	};
	[
		index,
		(currChord[index[1]] - currChord[index[0]]) ==
		(nextChord[index[1]] - nextChord[index[0]])
	];
};
// Test two chords
~checkParallelOct.(~currChordPO[0], ~nextChordValid[0], 4) == ~octavesAt[0]
)

// Test entire chord arrays and compare output to ~octavesAt.
(
~currChordPO.do { |n, i|
	(~checkParallelOct.(n, ~nextChordValid[i], 4)).postln;
};
)

/*************************************************************************************************************************/
// Check for parallel fifths
(
~checkParallel5th = { |currChord, nextChord, numVoices|
	var index = Array.new(4), result = false;
	var fifths = [7, 19, 31, 43, 55];

	for (0, (numVoices - 2)) { |i|

		for (1, (numVoices - 1)) { |j|

			fifths.do { |n|
				if ((currChord[j] - currChord[i]) == n) { index.add([i, j]) };

			};
		};
	};
	index.do { |i|
		result = result ||
		((currChord[i[1]] - currChord[i[0]]) ==
		(nextChord[i[1]] - nextChord[i[0]]));
	};
	result;
};
// Test two chords
~checkParallel5th.(~currChordPF[1], ~nextChordPF[1], 4);
)
{ 1000.do({ ~checkParallel5th.(~currChordPF[1], ~nextChordPF[1], 4); }) }.bench;

// Test entire chord arrays.
(
~currChordPF.do { |n, i|
	(~checkParallel5th.(n, ~nextChordPF[i], 4)).postln;
};
)

/*************************************************************************************************************************/
// Check root duplication
(
~checkRootDuplicat = { |nextChord|
	var chord, chordDegree, numRoot;

	//if (~enforceRootDuplicat == true) {

	chord = ~chordData[\chords][~chordData[\nextHarmony]];
	chordDegree = chord.select({ |item|
		(item[0] == nextChord[0]) ||
		(item[0] == nextChord[1]) ||
		(item[0] == nextChord[2]) ||
		(item[0] == nextChord[3])
	});
/*	numRoot = chordDegree.select({ |item|
		item[1] == "Rt";
	});
	(numRoot.size > 1);*/
	case
	{ ~enforceRootDuplicat == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 2)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 1) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 1)
	}
	{ ~enforce3rdDuplicat == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 1)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 2) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 1)
	}
	{ ~enforce5thDuplicat == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 1)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 1) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 2)
	}
};
// Test root duplicate
~checkRootDuplicat.(~nextChordRD);
)

/*************************************************************************************************************************/
// Get valid notes and enforce common tone in same voice
(
// In harmony_00
~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getValidNotes = { |nextChord|
	...
	if (~enforceCommonTone == true)

};
)

/*************************************************************************************************************************/
// Final check8 before chord gets added to validNextChord array
(
~chordIsValid = { |currChord, nextChord, numVoices|
	(
		(
			if (~enforceRootDuplicat == true) {
				~checkRootDuplicat.(nextChord)
			} { true }
		) &&
		(
			if (~enforceParallelOct == true) {
				~checkParallelOct.(currChord, nextChord, numVoices)
			} { true }
		) &&
		(
			if (~enforceParallel5th == true) {
				~checkParallel5th.(currChord, nextChord, numVoices)
			} { true }
		)
	)
};
)
