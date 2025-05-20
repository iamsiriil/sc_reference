(
"../sc_harmony_01_lib.scd".loadRelative;
"../sc_harmony_01_utils.scd".loadRelative;
"../sc_harmony_01_rules.scd".loadRelative;
"../sc_harmony_01_backtrack".loadRelative;
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
			};
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

/*************************************************************************************/
~gridPositionCounter = 0;
~createChordGrid = { |resolution, chord, duration|
	var totalDuration = ~chordData[\chordProg].collect { |p| p[1] };
	var grid = Array.new(totalDuration.sum / resolution);
	var chordDurationArray = Array.fill(4, {[]});

	chord.do { |n, i|
		var array = [n, duration];
		chordDurationArray.add(array);
	}

	(duration / resolution).do { |i|

		if (i == 0){
			grid[~gridPositionCounter] = chordDurationArray;
		} {
			grid[~gridPositionCounter] = [nil, nil, nil, nil];
		};
		~gridPositionCounter = ~gridPositionCounter + i;
	}
}
/*************************************************************************************/
~harmonizeProg = { |buildChord, firstChord|
	var resolution = 1;
	var harmony = Array.new(~chordData[\chordProg].size / resolution);

	harmony.add(firstChord.copy);
	~chordState[\currChord] = firstChord;

	~chordData[\chordProg].do { |c|

		~chordState[\nextCipher] = c[0];

		if (c[0].contains("A", 1) || c[0].contains("d", 1)) {
			//~enforceParallelOctaves = false;
			~enforceParallelFifths  = false;
		};

		while { ~getNextChords02.(buildChord, 0) == false } { ~toggleRules.() };

		~resetRule.();

		~chordState[\currChord] = ~chordState[\nextValidChords].choose;
		harmony.add(~chordState[\currChord].copy);
	}
}
)


/*************************************************************************************/
// Run test
(
var buildChord = Array.fill(4, {0}).postln;

~logger = true;
~loggerCount = 0;

// Update chordData and chordSate dicts with input data
~chordData[\chordProg] = [['CM', 2], ['AbA', 2]];
~chordState[\currChord] = [48, 55, 64, 72];
~chordState[\nextCipher] = 'AbA';

~chordState[\nextValidChords] = OrderedIdentitySet.new();

// Gather midi note numbers and note degree information for all chords in progression
~getChordDegreeArrays.();

// With that data, generate valid candidates for each voice for the next chord
~getValidNotes.();

// Run ~getNextChords to backtrack next valid chords
while { ~getNextChords02.(buildChord, 0) == false } { ~toggleRules.(~toggleCount) };

~toggleCount.postln;
//~getNextChords02.(buildChord, 0).postln;
~chordState[\nextValidChords].postln;

~resetChordDicts.(); ~resetRules.();
)

/*************************************************************************************/
// Experiments


~a = Array.fill(8, {[]});
~a[0] = [nil, nil, nil, nil];

"AA".contains("A", 1);

~prog = [['CM', 2], ['AbA', 2], ['EM', 1], ['CM', 4]];

~a = ~prog.collect { |p| p[1] };

