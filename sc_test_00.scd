(
~rangeIsValidB = { |note|
	if ((note >= 40) && (note <= 60)) { true } { false };
};

~rangeIsValidT = { |note|
	if ((note >= 48) && (note <= 67)) { true } { false };
};

~rangeIsValidA = { |note|
	if ((note >= 55) && (note <= 74)) { true } { false };
};

~rangeIsValidS = { |note|
	if ((note >= 60) && (note <= 81)) { true } { false };
};

~checkVoiceCross = {|lowerNote, higherNote|
	if (lowerNote < higherNote) { true } { false };
};

~noteIsValid = {
	arg nextChord, i;
	//var return;
	"~noteIsValid | Fcuntion call".postln;

	case (
		{ i == 0 }, {
			("~notIsValid | case i :" + i).postln;
			if (~rangeIsValidB.(nextChord[i])) { true } { false };
		},
		{ i == 1 }, {
			("~notIsValid | case i :" + i).postln;
			if (~rangeIsValidT.(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i])) { true } { false };
		},
		{ i == 2 }, {
			("~notIsValid | case i :" + i).postln;
			if (~rangeIsValidA.(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i])) { true } { false };
		},
		{ i == 3 }, {
			("~notIsValid | case i :" + i).postln;
			if (~rangeIsValidS.(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i])) { true } { false };
		}
	);

};

~currentChord = [36, 48, 55, 64];
~nextChord = Array.fill(4, {0});
~validNextChords = Array.new(10);

~numVoices = ~nextChord.size;
~validNotes = [[29, 33, 36, 41, 45], [41, 45, 48, 53, 57], [48, 53, 57, 58, 60], [57, 60, 65, 69, 72]];

~getNextChord = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid, result, nextChord = Array.fill(4, {0});;

	if (i == numVoices) {
		("i == numVoices | exit function | i :" + i + "| next chord : " + nextChord).postln;
		validNextChords.add(nextChord.copy);
	} {
		validNotes[i].do { |note|

			nextChord.put(i, note);

			isValid = ~noteIsValid.(nextChord, i);
			if (isValid) {
				~getNextChord.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
			} {
				nextChord.put(i, 0);
			};
		};
		validNextChords;
	};
};

~getNextChord.(~numVoices, ~nextChord, ~validNextChords, ~validNotes, 0);
("Valid next chords :" + ~validNextChords).postln;
//("Next chord :" + ~nextChord).postln;
)

~validNextChords.size;


~nextChord = Array.fill(4, {0});
~nextChord = [1, 2, 3, 4];



















