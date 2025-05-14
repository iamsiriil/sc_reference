

/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures
**************************************************************************************/
// Data Structures
(
// Dictionary containing information about the voices
~voiceData = Dictionary[
	// Range of each voice, from lowest note, to highest
	\voiceRange -> Dictionary[
		\bas -> [40, 60],
		\ten -> [48, 67],
		\alt -> [55, 74],
		\spn -> [60, 81]
	],
	// Allowed melodic intervals
	\validIntervals -> Dictionary[
		// All except tritone and sevenths. Spn, alt and ten, one octave. Bass, two
		\bas -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12, 13, 14,15, 16, 17, 19, 20, 21, 24],
		\ten -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\alt -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\spn -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12]
	],
	// Number of voices
	\numVoices -> 4,
	// Reference names for each of the voices
	\voiceNames -> ['bas', 'ten', 'alt', 'spn']
];

// Data structure containing sets of necessary chords and the chord progression to be played
~chordData = Dictionary[
	\chords -> nil,
	\progretion -> nil
];

// Data structure containing the state of chords as they're built and played'
~chordState = Dictionary[
	\currChord -> Array.new(),
	\nextChord -> Array.fill(4, {0}),
	\validNotes ->  nil
	\nextValidChords -> OrderedIdentitySet.new(),
	\lastValidChords -> nil,
	\nextCipher -> nil
];
)

/*************************************************************************************/
(
~getChordDegreeArrays = { |chordProg|
	//var chordProg = ~chordData[\chordProg];
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
)

/*************************************************************************************/
(
~getChordDegreePairs = { //|chordProg|
	var chordProg = ~chordData[\chordProg];
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
)

/*************************************************************************************/
(
~getChordVocalRange = { |cipher|
	//var cipher = ~chordState[\nextCipher];
	var voices = ~voiceData[\voiceNames];
	var chordNotes = ~chordData[\chords][cipher][\notes].as(OrderedIdentitySet);
	var voiceRange, dict;

	dict = Dictionary.new();

	voices.do { |v|
		voiceRange = ~voiceData[\voiceRange][v];
		dict[v] = chordNotes & (voiceRange[0]..voiceRange[1]);
	};
	~chordState[\validNotes] = dict;
};
)

/*************************************************************************************/
(
~resolveMelodicIntervals = {

};
)

/*************************************************************************************/
(
~resolveCommonTones = { |currChord|
	//var currChord = ~chordState[\currChord];
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
)

/*************************************************************************************/
// Get valid notes
(
~getValidNotes = {

	~getChordVocalRange.();

	if (~enforceMelodicIntervals == true) {
		~resolveMelodicIntervals.();
	};
	if (~enforceCommonTone == true) {
		~resolveCommonTones.();
	};
};
)

/*************************************************************************************/
// Get the corresponding degree of a note, given a cipher
(
~getNoteDegree = { |note, cipher|
	//var cipher = ~chordState[\nextCipher];
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];

	degree[notes.indexOf(note)];
};
)

/*************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord
(
~getChordNotesDegree = { |chord, cipher|
	//var cipher = ~chordState[\nextCipher];
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];
	var degreeArray = Array.new(~voiceData[\numVoices]);

	chord.do { |n|
		degreeArray.add(degree[notes.indexOf(n)]);
	};
	degreeArray;
};
)

/*************************************************************************************/
// list of note names (e.g. C)
(
~getNoteNames = { |notes|
	notes.collect { |note| ~midiRange[\name][note] };
};

/*************************************************************************************/
)
// list of note names with respective octaves (e.g. C4)
(
~getNoteNamesOct = { |notes|
	notes.collect { |note| ~midiRange[\octave][note] };
};
)
