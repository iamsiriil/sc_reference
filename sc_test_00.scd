(
~vRan = (
	spn: [60, 81],
	alt: [55, 74],
	ten: [48, 67],
	bas: [40, 60]
);
)

(
~rangeIsValid = IdentityDictionary[
	\spn -> { |note| (note >= 60) && (note <= 81) },
	\alt -> { |note| (note >= 55) && (note <= 74) },
	\ten -> { |note| (note >= 48) && (note <= 67) },
	\bas -> { |note| (note >= 40) && (note <= 60) }
];

~checkVoiceCross = { |lowerNote, higherNote| (lowerNote < higherNote) };

~noteIsValid = {
	arg nextChord, i;

	case (
		{ i == 0 }, {
			~rangeIsValid[\bas].(nextChord[i]);
		},
		{ i == 1 }, {
			~rangeIsValid[\ten].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
		},
		{ i == 2 }, {
			~rangeIsValid[\alt].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
		},
		{ i == 3 }, {
			~rangeIsValid[\spn].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
		}
	);

};
)

~noteIsValid.([50, 55], 1);

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












