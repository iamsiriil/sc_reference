(
"../sc_harmony_01_rules.scd".loadRelative;
"../sc_harmony_01_utils.scd".loadRelative;
"../sc_harmony_01_lib.scd".loadRelative;
)

/**************************************************************************************
- HARMONY 01 / Backtrack
**************************************************************************************/
// Test fixtures

~chordState[\validNotes][\spn];

(
// Gets all valid chords
~getNextChords = { |buildChord, i|

	"\n~chordState:\n".postln;

	~chordState.do { |i| i.postln };

	"\n~chordData:\n".postln;

	~chordData.do { |i| i.postln };

	"\nvoiceData:\n".postln;

	~voiceData.do { |i| i.postln };

	"\ni: %; buildChord: %".format(i, buildChord.put(1, 1)).postln;
};
)

(
var buildChord = Array.fill(4, {0});

// Create a progression, first chord and provide the next cipher, as input
~chordProg = [['CM', 2], ['FM', 2]];
~currChord = [48, 55, 60, 64];        // CM chord
~nextCipher = 'FM';                   // Next chord in FM

// Update chordData and chordSate dicts with input data
~chordData[\chordProg] = ~chordProg;
~chordState[\currChord] = ~currChord;
~chordState[\nextCipher] = ~nextCipher;
~chordState[\nextValidChords] = Array.new(100);

// Gather midi note numbers and note degree information for all chords in progression
~getChordDegreeArrays.();

// With that data, generate valid candidates for each voice for the next chord
~getValidNotes.().postln;

// Run ~getNextChords to backtrack next valid chords
~getNextChords.(buildChord, 0);

)
~resetChordDicts.(); ~resetRules.();

~chordState[\nextValidChords];















