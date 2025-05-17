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

~getNextChords2 = { |buildChord, i|
	var v = ~voiceData[\voiceNames].postln;
	var result = nil;

	block { |return|

		"First if: numVoices: %".format(~voiceData[\numVoices]).postln;
		if ((i == ~voiceData[\numVoices]) && (~chordIsValid.(buildChord).postln)) {
			~chordState[\nextValidChords].add(buildChord.copy);
			result = true;
			return.value(result);
		};

		"Second if".postln;

		"Valid Notes: % | i: %".format(~chordState[\validNotes][i][0], i).postln;

		if ((i > 0) && (~chordState[\validNotes][i][0].size == 1)) {
			buildChord.put(i, ~chordState[\validNotes][i][0].postln);
			result = ~getNextChords2.(buildChord, (i + 1));
			return.value(result);
		};

		"Loop".postln;
		~chordState[\validNotes][i].do { |n|
			buildChord.put(i, n);

			if (~checkVoiceSpacing.(buildChord, i)) {
				result = ~getNextChords2.(buildChord, (i + 1));
				if (result == true) {return.value(result)};
			} {
				buildChord.put(i, 0);
			};
		};

		result = false;
		return.value(result);
	};

	result;
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
~getValidNotes.();

~chordState[\validNotes][\bas].postln;
// Run ~getNextChords to backtrack next valid chords
~getNextChords2.(buildChord, 0);

)
~resetChordDicts.(); ~resetRules.();

~chordState[\nextValidChords];















