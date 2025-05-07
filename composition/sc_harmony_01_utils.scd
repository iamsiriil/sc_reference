s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures
**************************************************************************************/

(
~numVoices = 4;
~voiceNames = ["Bass", "Ten", "Alt", "Spn"];

// Data structure containing the state of chords as they're built and played'
~chordState = (
	\currChord,
	\nextChord,
	\validNotes,
	\collectValidChords
);

// Cata structure containing sets of necessary chords and the chord progression to be played
~chords = (
	\range,
	\progretion,
);
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
