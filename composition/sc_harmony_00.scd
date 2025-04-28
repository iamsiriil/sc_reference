s.boot;
s.quit;
/**************************************************************************************
- HARMONY 00
**************************************************************************************/

(
SynthDef(\sawtone, { |freq = 440, sus = 1|
	var snd = SinOsc.ar(freq) * Env.linen(0.2, sus, 0.4, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

// Test synths
(
Synth(\sawtone, [\freq, 64.midicps]);
Synth(\sawtone, [\freq, 55.midicps]);
Synth(\sawtone, [\freq, 48.midicps]);
Synth(\sawtone, [\freq, 36.midicps]);
)

(
~getOctaves = {
	arg root;
	var octaves = Array.new, temp = root;

	while { temp <= 127 } {
		octaves = octaves.add(temp);
		temp = temp + 12;
	};
	^octaves;
};
)

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

~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7, 8, 9];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getNextChord = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid, result;

	if (i == numVoices) {
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

~clock = TempoClock.new(100/60);

~t = { |chordProg|
	Task({
		var noteRange = [24, 28, 31, 36, 40, 43, 48, 52, 53, 55, 60, 64, 67, 72, 76, 79, 84, 88, 91];
		var chordShift = ('c': 0, 'f': 5, 'g': 7);

		var currentChord = [36, 48, 55, 64];

		var tempo = 2;
		var duration = tempo / ~clock.tempo;

		var chords = ();
		chordProg.do { |c|
			chords[c] = (noteRange + chordShift[c]);
		};

		chords.postln;

		chordProg.do { |c, i|
			var validNotes = Array.fill(4, {[]});
			var nextChord = Array.fill(4, {0});
			var validNextChords, buildChord = Array.fill(4, {0});
			var soprano, alto, tenor, bass;
			var root = chords[c][0];

			if (i == 0) {
				nextChord = currentChord;
			} {
				4.do { |j|
					validNotes[j] = ~getValidNotes.(chords[c], currentChord[j]);
				};
				validNextChords = Array.new(10);

				~getNextChord.(currentChord.size, buildChord, validNextChords, validNotes, 0);
				nextChord = validNextChords.choose;
				validNextChords = nil;
			};

			validNotes = nil;

			soprano = { |note, duration|
				Task({
					Synth(\sawtone, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			alto = { |note, duration|
				Task({
					Synth(\sawtone, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			tenor = { |note, duration|
				Task({
					Synth(\sawtone, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			bass = { |note, duration|
				Task({
					Synth(\sawtone, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			soprano.(nextChord[3], duration).play(~clock, quant: 1);
			alto.(nextChord[2], duration).play(~clock, quant: 1);
			tenor.(nextChord[1], duration).play(~clock, quant: 1);
			bass.(nextChord[0], duration).play(~clock, quant: 1);
			tempo.wait;

			currentChord = nextChord;
		}
	});
};

~chordProg = ['c', 'f', 'g', 'c', 'f', 'f', 'g', 'c'];
~t.(~chordProg).play(~clock, quant: 1);
)


