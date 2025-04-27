s.boot;
s.quit;
/**************************************************************************************
- HARMONY 00
**************************************************************************************/

(
SynthDef(\soprano, { |freq = 440, sus = 1|
	var snd = Saw.ar(freq) * Env.linen(0.2, sus, 0.4, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;

SynthDef(\alto, { |freq = 440, sus = 1|
	var snd = Saw.ar(freq) * Env.linen(0.2, sus, 0.4, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;

SynthDef(\tenor, { |freq = 440, sus = 1|
	var snd = Saw.ar(freq) * Env.linen(0.2, sus, 0.4, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;

SynthDef(\bass, { |freq = 440, sus = 1|
	var snd = LFSaw.ar(freq) * Env.linen(0.2, sus, 0.4, 0.1, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

// Test synths
(
Synth(\soprano, [\freq, 64.midicps]);
Synth(\alto, [\freq, 55.midicps]);
Synth(\tenor, [\freq, 48.midicps]);
Synth(\bass, [\freq, 36.midicps]);
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

~chordIsValid = {
	arg nextChord, root, i;
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

~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7, 8, 9];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getNextChord = {
	arg numVoices, currentChord, nextChord, validNotes, root, i;
	var isValid, j;

	("~getNextChord | function call | recursion:" + i).postln;

		if (i == numVoices) { // && ~chordIsValid.(currentChord, nextChord)) {
		("~getNextChord | exit function | i == " ++ i ++ " | nextChord : " + nextChord).postln;
			nextChord;
		} {

			if (i < numVoices) {

				"~getNextChord | i < numVoices".postln;

			//~b = block { |result|

				validNotes[i].do { |n|

					nextChord[i] = n;
					("~getNextChord | validNotes[" ++ i ++ "] loop | nextChord[" ++ i ++"] :" + nextChord[i]).postln; // <----- STOPS HERE

					isValid = ~noteIsValid.(nextChord, i);
					("~getNextChord | ~noteIsValid : " + isValid).postln;
					if (isValid) {

						("~getNextChord | ~noteIsValid | nextChord[" ++ i ++ "] : " + nextChord[i]).postln;
						i = i + 1;
						nextChord = ~getNextChord.(numVoices, currentChord, nextChord, validNotes, root, i);
						("~getNextChord | after recursion | nextChord :" + nextChord).postln;
						if (nextChord.notNil) { nextChord };
					} {
						nextChord[i] = 0;
						("~getNextChord | ~noteIsValid fail | nextChord[" ++ i ++ "] : " + nextChord[i]).postln;
					};
					nil;
				//};
			};
			nextChord;
			//("~getNextChord | result = nil | recursion :" + i + "| result :" + result).postln;
			//nextChord = ~b.(result);
		};
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
			var validNotes = Array.fill(4, {[]}), nextChord = [], getChord;
			var soprano, alto, tenor, bass;
			var root = chords[c][0];
			("chordProg.do | c :" + c + "| i :" + i).postln;

			if (i == 0) {
				nextChord = currentChord;
			} {
				getChord = Array.fill(4);

				4.do { |j|
					validNotes[j] = ~getValidNotes.(chords[c], currentChord[j]);
					("~getValidNotes | validNotes :" + validNotes).postln;
				};
				nextChord = ~getNextChord.(currentChord.size, currentChord, getChord, validNotes, root, 0);
				("~getNextChord | back to task, after function termination | nextChord :" + nextChord).postln;
			};

			validNotes = nil;

			("SATB | nextChord :" + nextChord).postln;
			soprano = { |note, duration|
				Task({
					Synth(\soprano, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			alto = { |note, duration|
				Task({
					Synth(\alto, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			tenor = { |note, duration|
				Task({
					Synth(\tenor, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			bass = { |note, duration|
				Task({
					Synth(\bass, [
						\freq, note.midicps,
						\sus, max(duration - 0.4, 0.5)
					]);
					tempo.wait;
				});
			};

			(
				soprano.(nextChord[3], duration).play(~clock, quant: 1);
				alto.(nextChord[2], duration).play(~clock, quant: 1);
				tenor.(nextChord[1], duration).play(~clock, quant: 1);
				bass.(nextChord[0], duration).play(~clock, quant: 1);
				tempo.wait;
			);

			currentChord = nextChord;

		}
	});
};


~chordProg = ['c', 'f', 'g', 'c'];
~t.(~chordProg).play(~clock, quant: 1);
)


