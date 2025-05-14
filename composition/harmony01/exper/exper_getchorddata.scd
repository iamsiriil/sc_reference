os.boot;

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
	\progression -> nil,
	\nextCipher -> nil
];

~chordState = Dictionary[
	\currChord -> Array.new(),
	\nextChord -> Array.fill(4, {0}),
	\validNotes ->  nil,
	\nextValidChords -> OrderedIdentitySet.fill(50, {[]}),
	\nextHarm -> nil;
];
)

/*************************************************************************************/
// Get chords from chord progression as note - degree pairs
(
~chordProg = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]];

~getChordsDegreePairs = { |chordProg|
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

~chordData[\chords] = ~getChordsDegreePairs.(~chordProg);
~chordData[\progression] = ~getChordsDegreePairs;
)

/*************************************************************************************/
// Get chord notes and degrees as separate arrays
(
~chordProg = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]];

~getChords = { |chordProg|
	var ciphers, dictChords, dict;

	ciphers = chordProg.collect { |c| c[0]};
	ciphers.asSet;

	dict = Dictionary.new();
	dictChords = Dictionary.new();

	ciphers.do { |c|
		dict[\notes] = ~triads[c][\notes];
		dict[\degree] = ~triads[c][\degree].wrapExtend(~triads[c][\notes].size);

		dictChords[c] = dict;
	};
	~chordData[\chords] = dictChords;
};
~getChords.(~chordProg);
~chordData[\chords][\FM][\notes];
)

/*************************************************************************************/
// Get the corresponding degree of a note, given a cipher
(
~getNoteDegree = { |note, cipher|
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];
	degree[notes.indexOf(note)];
};

~getNoteDegree.(31, 'FM');
)

/*************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord
(
~getChordNotesDegree = { |chord, cipher|
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];
	var degreeArray = Array.new(4);

	chord.do { |n|
		degreeArray.add(degree[notes.indexOf(n)]);
	};
	degreeArray;
};
~chord = [48, 60, 64, 67];
~getChordNotesDegree.(~chord, 'CM');
)

/*************************************************************************************/

(
~getChordVocalRange = { |cipher|
	var voices = ~voiceData[\voiceNames];
	var chordNotes = ~chordData[\chords][cipher][\notes].as(OrderedIdentitySet);
	var voiceSet, voiceRange, dict;

	dict = Dictionary.new();

	voices.do { |v|
		voiceRange = ~voiceData[\voiceRange][v];
		voiceSet = OrderedIdentitySet.newFrom((voiceRange[0]..voiceRange[1]));
		dict[v] = chordNotes & voiceSet;
	};
	~chordState[\validNotes] = dict;
};
~getChordVocalRange.('CM');
~chordState[\validNotes];
)

/*************************************************************************************/

/*************************************************************************************/

(
~resolveCommonTones = { |currChord|
	var validNotes = ~chordState[\validNotes];
	var voiceNames = ~voiceData[\voiceNames];

	if (~enforceRootPosition == true) {
		voiceNames = voiceNames.drop(1);
		currChord = currChord.drop(1);
	};

	voiceNames.do { |v, i|
		var set = [currChord[i]];
		if (set.isSubsetOf(~chordState[\validNotes][v])) {
			~chordState[\validNotes][v] = (~chordState[\validNotes][v] & set);
		};
	};
};

~enforceRootPosition = true;
~currChordFM = [41, 53, 60, 69];

~resolveCommonTones.(~currChordFM);
~chordState[\validNotes][\spn];
)







/*************************************************************************************/
// Get valid notes
(
~currChord = [[48, 60, 64, 67], [48, 55, 60, 64], [48, 64, 67, 72], [52, 60, 72, 79], [52, 60, 67, 72], [52, 55, 60, 72]];
~chordState[\currChord] = ~currChord[0];
~chordState[\nextHarm] = ~chordProg[1][0];

~getChordVocalRange = { |voices, nextHarm|
	var chordRanges = Array.fill(4, {[]});

	voices.do { |v, i|
		chordRanges[i] = ~chordData[\chords][nextHarm].select { |n|
			(n[0] >= ~voiceData[\voiceRange][v][0]) &&
			(n[0] <= ~voiceData[\voiceRange][v][1])
		};
	};
	chordRanges;
};

~vRange = ~getChordVocalRange.(~voiceData[\voiceNames], ~chordState[\nextHarm]);
)

/*************************************************************************************/

~chordData[\chords]
(
~getDegree = { |note|
	var chord = ~chordData[\currHarm];
	var chordArray = ~chordData[\chords][chord].asArray;
	var degreeArray = ~chordData[]
};
)



























/*************************************************************************************/
// Tests
(
~testArray = Array.fill(4, {[]});

~vRange.do { |r, i|
		~testArray[i] = r.select { |n|
		~voiceData[\validIntervals][~voiceData[\voiceNames][i]].includes((n[0] - ~currChord[0][i]).abs);
		}
	};
)
~testArray[3];

(
~testArray2 = Array.fill(4, {[]});

~currChord[0].do { |r, i|
	~testArray2[i] = ~testArray[i].collect { |n|
		n[0] == r;
	};
};
)
~testArray2

(
~b = ~voiceData[\voiceRange][\bas];
~bSet = OrderedIdentitySet.newFrom((~b[0]..~b[1]));

~cM = ~triads[\CM][\notes].as(OrderedIdentitySet);
~nt = ~currChord[0][0];
~nSet = OrderedIdentitySet.new();
~nSet.add(~nt);
~cM & ~bSet & ~nSet;
)


Set.newFrom((1..12))
Set[4, 6, 45, 61, -2] & (1..12).asSet

~range = (~voiceData[\voiceRange][\spn][0]..~voiceData[\voiceRange][\spn][1]).as(OrderedIdentitySet);

~range & Set[67, 65, 23, 45]










(
var i = 2;
~vRange[i].postln;
~test[i].postln;
)
nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };



(
~getValidNotes = {
	var chordB, chordT, chordA, chordS;
	var nextHarm = ~chordData[\nextHarm];

	chordB = ~chordData[\chords][nextHarm].collect { |n| (n >= ~voiceData[\voiceRange][\bas][0]) && (n >= ~voiceData[\voiceRange][\bas][1]) };
};
~getValidNotes.();
)









