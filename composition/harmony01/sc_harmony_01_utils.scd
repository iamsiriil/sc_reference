s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures
**************************************************************************************/

(
~voices = Dictionary[
	\numVoices -> 4,
	\voiceRange -> [[40, 60], [48, 67], [55, 74], [60, 81]],
	\voiceNames -> ["Bass", "Ten", "Alt", "Spn"]
];

// Cata structure containing sets of necessary chords and the chord progression to be played
~chordData = [
	\chords ->
	\progretion ->
];

// Data structure containing the state of chords as they're built and played'
~chordState = [
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
