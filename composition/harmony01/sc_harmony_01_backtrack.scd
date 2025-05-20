/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
~getNextChords = { |buildChord, i|
	var v = ~voiceData[\voiceNames][i];
	var result = nil;

	// Logger
	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords: Function Call".format(~loggerCount).postln; };

	block { |return|

		if (i == 4) {
			if (~chordIsValid.(buildChord)) {
				~chordState[\nextValidChords].add(buildChord.copy);
				result = true;
				return.value(result);
			};
		};

		if ((i > 0) && (~chordState[\validNotes][v].size == 1)) {
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
)