(
"./sc_backtracking_02_lib.scd".loadRelative;
"./sc_backtracking_02_utils.scd".loadRelative;
"./sc_backtracking_02_rules.scd".loadRelative;
)

(
~getNextChords = { |buildChord, i|
	var v = ~voiceData[\voiceNames][i];
	var result = nil;

	// Logger
	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords: Function Call".format(~loggerCount).postln; };

	block { |return|

		if (i == 4) {
			if (~chordIsValid.(buildChord)) {
				~chordState[\nextValidChords].add(buildChord.copy).postln;
				result = true;
				return.value(result);
			};
		};

		if ((i > 0) && (~chordState[\validNotes][v].size == 1)) {
			buildChord[i] = ~chordState[\validNotes][v].asArray.at(0);
			result = ~getNextChords.(buildChord, (i + 1));
			return.value(result);
		};

		~chordState[\validNotes][v].do { |n|

			buildChord[i] = n;

			if (~checkVoiceSpacing.(buildChord, i)) {
				result = ~getNextChords.(buildChord, (i + 1));
				if (result == true) { return.value(result) };
			};

			buildChord[i] = 0;
		};

		result = false;
		return.value(result);
	};
	result;
};

~getNextChords02 = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid;
	var voice = ~voiceData[\voiceNames][i];

	if ((i == numVoices) && (~chordIsValid.(nextChord))) {
		validNextChords.add(nextChord.copy);
	} {
		if ((i > 0) && (~chordState[\validNotes][v].size == 1)) {
			nextChord.put(i, ~chordState[\validNotes][v].asArray.at(0));
			~getNextChords02.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
		};

		~chordState[\validNotes][voice].do { |note|

			nextChord.put(i, note);

			isValid = ~checkVoiceSpacing.(nextChord, i);
			if (isValid) {
				~getNextChords02.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
			} {
				nextChord.put(i, 0);
			};
		};
		nil;//validNextChords;
	};
};
)



(
var buildChord = Array.fill(4, {0});

~chordData[\chordProg] = [['CM', 1], ['FM', 1]];
~chordState[\currChord] = [48, 55, 64, 72];
~chordState[\nextCipher] = 'FM';

~validNextChords = OrderedIdentitySet.new();
~getChordDegreeArrays.();
~getValidNotes.();

~getNextChords02.(4, buildChord, ~validNextChords, ~chordState[\validNotes], 0);
)

~validNextChords;