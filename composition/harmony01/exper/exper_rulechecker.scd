// Test fixtures
(
~currChord00   = [[41, 53, 60, 69], [41, 57, 65, 72], [41, 57, 60, 65], [43, 52, 64, 71], [43, 52, 59, 64], [40, 55, 60, 72]];
~nextChord00PO = [[48, 60, 64, 67], [48, 55, 72, 76], [48, 55, 64, 72], [40, 55, 67, 72], [48, 55, 64, 67], [48, 57, 65, 77]];
~octavesAt     = [[[0, 1], true]  , [[0, 2], true]  , [[0, 3], true]  , [[1, 2], true]  , [[1, 3], true]  , [[2, 3], true] ];
)

/*************************************************************************************************************************/
// Check range between voices
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
