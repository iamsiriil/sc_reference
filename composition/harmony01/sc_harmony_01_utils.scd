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
		\bas -> [],
		\ten -> [],
		\alt -> [],
		\spn -> []
	],
	// Number of voices
	\numVoices -> 4,
	// refference names for each of the voices
	\voiceNames -> ["bas", "ten", "alt", "spn"]
];

// Data structure containing sets of necessary chords and the chord progression to be played
~chordData = Dictionary[
	\chords -> Dictionary[
		\Cm -> OrderedIdentitySet[[0, "Rt"]...]
	],
	\progretion ->
	\nextChord ->
];

// Data structure containing the state of chords as they're built and played'
~chordState = Dictionary[
	\currChord ->
	\nextChord ->
	\validNotes ->
	\collectValidChords ->
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
