s.boot;

/**************************************************************************************
- HARMONY 01 / Experiment / Get chord data
**************************************************************************************/
// Data Structures
(
~voiceData = Dictionary[
	\voiceRange -> Dictionary[
		\bas -> [40, 60],
		\ten -> [48, 67],
		\alt -> [55, 74],
		\spn -> [60, 81]
	],
	\validIntervals -> Dictionary[
		\bas -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12, 13, 14,15, 16, 17, 19, 20, 21, 24],
		\ten -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\alt -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\spn -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12]
	],
	\numVoices -> 4,
	\voiceNames -> ['bas', 'ten', 'alt', 'spn']
];

~chordData = Dictionary[
	\chords -> nil,
	\progretion -> nil,
	\nextCipher -> nil
];

~chordState = Dictionary[
	\currChord -> Array.new(),
	\nextChord -> Array.fill(4, {0}),
	\validNotes ->  OrderedIdentitySet.fill(4, {[]}),
	\nextValidChords -> OrderedIdentitySet.fill(50, {[]}),
	\nextHarm -> nil;
];
)

/*************************************************************************************/
// Get chords from chord progression passed as argument
(
~chordProg = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]];

~getChords = { |chordProg|
	var chords, dict;

	chords = chordProg.collect { |c| c[0] };    // Separate ciphers from durations
	chords.asSet;                               // Remove duplicates

	dict = Dictionary.new();

	chords.do { |c|
		var notes = OrderedIdentitySet.new();
		var degreeArr = ~triads[c][\degree].wrapExtend(~triads[c][\notes].size);

		~triads[c][\notes].do { |n, i|
			var arr = [n, degreeArr[i]];
			notes.add(arr);
		};
		dict[c] = notes;
	};
	dict;
};

~chordData[\chords] = ~getChords.(~chordProg);
~chordData[\progretion] = ~chordProg;
)
/*************************************************************************************/
// Get valid notes
(
~currChord = [[48, 60, 64, 67], [48, 55, 60, 64], [48, 64, 67, 72], [52, 60, 72, 79], [52, 60, 67, 72], [52, 55, 60, 72]];
~chordState[\currChord] = ~currChord[0];
~chordState[\nextHarm] = ~chordProg[1][0];

~getValidNotes = {
	var chordB, chordT, chordA, chordS;
	var nextHarm = ~chordData[\nextHarm];

	chordB = ~chordData[\chords][nextHarm].collect { |n| (n >= ~voiceData[\voiceRange][\bas][0]) && (n >= ~voiceData[\voiceRange][\bas][1]) };
};
~getValidNotes.();
)

(
var chordB, chordT, chordA, chordS;
var nextHarm = ~chordState[\nextHarm];

~chordData[\chords][nextHarm].select { |n| (n[0] >= ~voiceData[\voiceRange][\bas][0]) && (n[0] <= ~voiceData[\voiceRange][\bas][1]) };
)
~chordData[\chords][]
















