s.boot;
s.quit;

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
	\voiceNames -> ["bas", "ten", "alt", "spn"]
];

// Data structure containing sets of necessary chords and the chord progression to be played
~chordData = Dictionary[
	\chords -> Dictionary[
		\Cm -> OrderedIdentitySet[[0, "Rt"]...] // Example
	],
	\progretion -> nil,
	\nextCipher -> nil
];

// Data structure containing the state of chords as they're built and played'
~chordState = Dictionary[
	\currChord -> Array.new(),
	\nextChord -> Array.fill(4, {0}),
	\validNotes ->  OrderedIdentitySet.fill(4, {[]}),
	\nextValidChords -> OrderedIdentitySet.fill(50, {[]})
];
)

(
// ~getMIDINoteNames -> Takes a sequence of midi numbers and returns the corresponting
// list of note names. C
~getMIDINoteNames = { |notes|
	notes.collect { |note| ~midiRange[\name][note] };
};

// ~getMIDINoteNamesOct -> Takes a sequence of midi numbers and returns the corresponding
// list of note names with respective octaves. C4
~getMIDINoteNamesOct = { |notes|
	notes.collect { |note| ~midiRange[\octave][note] };
};
)
