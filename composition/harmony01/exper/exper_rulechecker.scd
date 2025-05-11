// Test fixtures
(
// Test parallel octaves
~currChordPO = [[41, 53, 60, 69], [41, 57, 65, 72], [41, 57, 60, 65], [43, 52, 64, 71], [43, 52, 59, 64], [40, 55, 60, 72]];
~nextChordPO = [[48, 60, 64, 67], [48, 55, 72, 76], [48, 55, 64, 72], [40, 55, 67, 72], [48, 55, 64, 67], [48, 57, 65, 77]];
//~nectChordPOValid =
~octavesAt     = [[[0, 1], true]  , [[0, 2], true]  , [[0, 3], true]  , [[1, 2], true]  , [[1, 3], true]  , [[2, 3], true] ];

// Test parallel fifths

/*~currChordPF
~nextChordPF
~nextChordPFValid
~fifthsAt*/

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
~checkParallelOct = { |cChord, nChord, cSize|
	var index;
	var octaves = [12, 24, 36, 48, 60];

	for (0, (cSize - 2)) { |i|

		for (1, (cSize - 1)) { |j|

			octaves.do { |oct|
				if ((cChord[j] - cChord[i]) == oct) { index = [i, j] };
			};
		};
	};
	[index, (cChord[index[1]] - cChord[index[0]]) == (nChord[index[1]] - nChord[index[0]])];
};
// Test two chords
~checkParallelOct.(~currChordOctP[0], ~nextChordOctP[0], 4) == ~octavesAt[0]
)

// Test entire chord arrays and compare output to ~octavesAt.
(
~currChordOctP.do { |n, i|
	(~checkParallelOct.(n, ~nextChordOctP[i], 4) == ~octavesAt[i]).postln;
};
)

/*************************************************************************************************************************/
// Check for parallel fifths
(
~checkParallel5th = { |currChord, nextChord, numVoices|
	var idx;
	var fifths = [7, (12 + 7), (24 + 7), (36 + 7), (48 + 7)];

	for (0, (numVoices - 2)) { |i|

		for (1, (numVoices - 1)) { |j|

			fifths.do { |n|
				if ((currChord[j] - currChord[i]) == n) { idx = [i, j] };
			};
		};
	};
	[
		idx,
		(currChord[idx[1]] - currChord[idx[0]]) == (nextChord[idx[1]] - nextChord[idx[0]])
	];
};
// Test two chords
~checkParallel5th.(~currChordOctP[0], ~nextChordOctP[0], 4) == ~octavesAt[0]
)
)

/*************************************************************************************************************************/
// Check root duplication
(
~checkRootDuplicat = { |nextChord|
	var chord, chordDegree, numRoot;

	if (~enforceRootDuplicat == true) {
		chord = ~chordData[\chords][~chordData[\nextHarmony]];
		chordDegree = chord.select({ |item|
			(item[0] == nextChord[0]) ||
			(item[0] == nextChord[1]) ||
			(item[0] == nextChord[2]) ||
			(item[0] == nextChord[3])
		});
		numRoot = chordDegree.select({ |item|
			item[1] == "Rt";
		});
		if (numRoot.size == 2) { true } { false }
	};
};
// Test root duplicate
~checkRootDuplicat.(~nextChordRD);
)

/*************************************************************************************************************************/
// Get valid notes and enforce common tone in same voice
(
~getValidNotes = { |nextChord|
	...
	if (~enforceCommonTone == true)

};
)

/*************************************************************************************************************************/

Set[[12, "a"], [45, "b"], [61, "c"], [32, "d"]].collect({ |n| n[1]})














