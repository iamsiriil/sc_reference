/*************************************************************************************/
// TONALITY
(
// Sets chord root in first octave
~root = 7;

~key = 'M';
~scales = Dictionary[
	\M -> [0, 2, 4, 5, 7, 9, 11],  // Major scale
	\Nm -> [0, 2, 3, 5, 7, 8, 10], // Natural minor scale
	\Hm -> [0, 2, 3, 4, 7, 8, 11]  // Harmonic minor scale
];

~noteNames = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"];

~keyScale = ~scales[~key].collect { |n| ~noteNames.wrapAt(n + ~root) };
)

/*************************************************************************************/
// CHORD TYPE
(
// Chord intervals as offset
~chordOffset = Dictionary[
	// Triads
	\A -> [0, 4, 8],
	\M -> [0, 4, 7],
	\m -> [0, 3, 7],
	\d -> [0, 3, 6],
	// Seventh chords
	\M7 -> [0, 4, 7, 11],
	\m7 -> [0, 3, 7, 10],
	\D7 -> [0, 4, 7, 10],
	\5d7 -> [0, 3, 6, 10],
	\d7 -> [0, 3, 6, 9]
];
// First octave in midi numbers
~firstOct = (0..11);
// Returns the chord notes for the given root in the first octave
~chord = (~chordOffset + ~root).collect { |n| ~firstOct.wrapAt(n) };
// Extends chord notes over midi range
~notes = OrderedIdentitySet.new();
~chord.do { |note|
	var temp = note;
	while { temp <= 127 } {
		~notes.add(temp);
		temp = temp + 12;
	};
};
~notes.sort;
)

/*************************************************************************************/
// CHORD
(
~prog = ['GM', 'CM7', 'C#5d7', 'D7', 'GM'];
~getChordNotes = { |prog, key|

	prog = prog.asSet;

};


/*************************************************************************************/
// Get chord notes, within MIDI range, and respective degrees, as paired arrays

~getChordDegreePairs = { |triads, chordProg|
	var ciphers, dict;

	//chords = (chordProg.collect { |c| c[0] }).asSet;    // Separate ciphers from durations
	ciphers = chordProg.asSet;
	dict = Dictionary.new();

	ciphers.do { |c|
		var notes;

		notes = triads[c][\notes] +++ triads[c][\degree].bubble(1);
		dict[c] = notes;
	};
	dict.postln;
};
)
