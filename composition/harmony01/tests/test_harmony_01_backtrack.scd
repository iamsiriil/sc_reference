(
"../sc_harmony_01_rules.scd".loadRelative;
"../sc_harmony_01_utils.scd".loadRelative;
"../sc_harmony_01_lib.scd".loadRelative;
)

/**************************************************************************************
- HARMONY 01 / Backtrack
**************************************************************************************/
// Test fixtures
(
~logger = true;
~loggerCount = 0;
)

/*************************************************************************************/
// Gets first valid chord
(
~getNextChords02 = { |buildChord, i|
	var v = ~voiceData[\voiceNames][i];
	var result = nil;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords02: Function Call".format(~loggerCount).postln; };

	block { |return|

		if (i == 4) {
			if (~chordIsValid.(buildChord)) {
				~chordState[\nextValidChords].add(buildChord.copy);
				result = true;
				return.value(result);
			} {
				~toggleRules.();
				result = false;
				return.value(result);
			}
		};

		if ((i > 0) && (~chordState[\validNotes][v].size == 1)) {
			buildChord[i] = ~chordState[\validNotes][v].asArray.at(0);
			result = ~getNextChords02.(buildChord, (i + 1));
			return.value(result);
		};

		~chordState[\validNotes][v].do { |n|

			buildChord[i] = n;
			"Build Chord: %".format(buildChord).postln;

			if (~checkVoiceSpacing.(buildChord, i)) {
				result = ~getNextChords02.(buildChord, (i + 1));
				if (result == true) { return.value(result) };
			};

			buildChord[i] = 0;
			"Build Chord: %".format(buildChord).postln;

		};

		result = false;
		return.value(result);
	};
	result;
};
)

(
var buildChord = Array.fill(4, {0}).postln;

~logger = true;
~loggerCount = 0;

// Update chordData and chordSate dicts with input data
~chordData[\chordProg] = [['CM', 2], ['G#d', 2]];
~chordState[\currChord] = [48, 55, 60, 64];
~chordState[\nextCipher] = 'G#d';

~chordState[\nextValidChords] = OrderedIdentitySet.new();

// Gather midi note numbers and note degree information for all chords in progression
~getChordDegreeArrays.();
//~chordData[\chords][\EM][\notes];
// With that data, generate valid candidates for each voice for the next chord
~getValidNotes.();

~chordState[\validNotes][\ten].postln;
// Run ~getNextChords to backtrack next valid chords
~getNextChords02.(buildChord, 0);
~chordState[\nextValidChords].postln;

)
~resetChordDicts.(); ~resetRules.();
~voiceData[\numVoices]
/*************************************************************************************/
// Experiments

~chordState[\validNotes][\alt].asArray[0]

(
var set = OrderedIdentitySet.new;
var num = 0;

set.add([60]);
set.asArray[0][0];
)

~set = OrderedIdentitySet.newFrom([[10]]);
~set.asArray[0][0];

y = [\a, \b, \c];
y.atAll([0, 2]);







