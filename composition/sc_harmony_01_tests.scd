s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Data Library
**************************************************************************************/

(
~testChords = [
	[[48, 60, 64, 67], "C", "Root"],
	[[40, 57, 60, 69], "A", "2Inv"]
];
~getChordNoteNames = { |chord|
	chord.collect { |n| ~midiRange[\name][n] };
};
)
~chords[\Cd][0]
~getChordNoteNames.(~chords[\Cd][0])

~isRoot = { |chord, index|
	if (chord[index] == )
}

~midiRange[\octave]
45.key

// Is root being duplicated

// Intervals between chord notes are valid

// Paralelle 5ths

// Parallele octaves

x = [1, 2, 2, 3, 5, 1]
x.asSet

"D#/Eb".split($/)

~a = ~triads[\Cd][2];
~b = ~a.asArray.wrapExtend(~triads[\Cd][0].size)
