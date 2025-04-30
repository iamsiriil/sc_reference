(
~inArray = { |array, element|
	var isIn;

	array.do { |e|
		if (e == element) { isIn = true };
	};
	if (isIn == true) { true } { false };
};

~notInArray = { |array, element|
	var notIn;

	array.do {
		if (e == element) { notIn = false };
	};
	if (notIn == false) { true } { false };
};

~rangeIsValid = IdentityDictionary[
	\spn -> { |note| (note >= 60) && (note <= 81) }, // C4-A5
	\alt -> { |note| (note >= 55) && (note <= 74) }, // G3-D5
	\ten -> { |note| (note >= 48) && (note <= 67) }, // C3-G4
	\bas -> { |note| (note >= 40) && (note <= 60) }  // E2-C4
];

~checkVoiceCross = { |lowerNote, higherNote| (lowerNote < higherNote) };

~noteIsValid = {
	arg nextChord, i;
	var result;

	"~noteIsValid | Function Call | i: %".format(i).postln;

	case
	{ i == 0 } {
		result = (~rangeIsValid[\bas].(nextChord[i]));
	}
	{ i == 1 } {
		result = ((~rangeIsValid[\ten].(nextChord[i])) && (~checkVoiceCross.(nextChord[i - 1], nextChord[i])));
	}
	{ i == 2 } {
		result = ((~rangeIsValid[\alt].(nextChord[i])) && (~checkVoiceCross.(nextChord[i - 1], nextChord[i])));
	}
	{ i == 3 } {
		result = ((~rangeIsValid[\spn].(nextChord[i])) && (~checkVoiceCross.(nextChord[i - 1], nextChord[i])));
	};
	result;
};

// Gets the first valid chord it finds
~getNC = {
	arg numVoices, nextChord, validNextChords, validNotes, i, counter;
	var result;

	"Recursion #% | i: %".format(counter, i).postln;
	counter = counter + 1;

	case
	{ (i < numVoices) && (~inArray.(nextChord, 0)) } {

		validNotes[i].do { |note|

			nextChord.put(i, note);

			if (~noteIsValid.(nextChord, i)) {

				~getNC.(numVoices, nextChord, validNextChords, validNotes, (i + 1), counter);
			} {
				nextChord.put(i, 0);
			};
			nil;
		};
	}
	{ (i == numVoices) } {
		"Exit #3 | Next Chord: %".format(nextChord).postln;
		validNextChords.add(nextChord.copy);
		nextChord;
	};
	nextChord;
};
)

(
var buildChord = Array.fill(4, {0});
var validNextChord = List.new();
var validNotes = [[41, 45, 48, 53], [48, 53, 57, 60], [57, 60, 65, 69], [65, 69, 72, 77]];
var counter = 0;

var out = ~getNC.(4, buildChord, validNextChord, validNotes, 0, counter);
"~getNC | out: %".format(out).postln;
~counter = 0;
"Valid Next Chord: %".format(validNextChord[0]).postln;
)
