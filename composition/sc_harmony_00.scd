s.boot;

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
~chordIsValid = {

};

~noteIsValid = {

};

~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7, 8, 9];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getNextChord = {
	arg currentchord, nextchord, validNotes, i;
	var numVoices = currentChord.size;
	var result;

	if ((i == numVoices) && ~chordIsValid.(currentChord, nextChord)) {
		^nextChord;
	};

	if (i < numVoices) {

		validNotes[i].do { |n|
			nextChord[i] = n;

			if (~noteIsValid.(currentChord[i], nextChord[i])) {
				result = ~getNextChord.(currentChord, nextChord, validNotes, i + 1);
				if (result.notNil) { ^result };
			} {
				nextChord[i] = 0;
			}
			result = nil;
		};
	};
};

~clock = TempoClock.new(100/60);

~t = { |chordProg = []|
	Task({
		var noteRange = [24, 28, 31, 36, 40, 43, 48, 52, 53, 55, 60, 64];
		var chordShift = ('c': 0, 'f': 5, 'g': 7);

		var chords = ();
		var chordProg.do { |c|
			chords[c] = (noteRange + chordShift[c]);
		};
		var currentChord = [36, 48, 55, 64];

		var tempo = 2;
		var duration = tempo / ~clock.tempo;


		chordProg.size.do { |c, i|
			var validNotes = Array.fill(4, {[]}), nextChord;
			var soprano, alto, tenor, bass;

			if (i == 0) {
				nextChord = currentChord;
			} {
				nextChord = Array.fill(4, 0);

				4.do { |j|
					validNotes[j] = ~getValidNotes.(chords[c], currentNote[j]);
				};
				nextChord = ~getNextChord.(currentChord, nextChord, validNotes, 0);
			};

			validNotes.nil;

			soprano = Task({
				Synth(\soprano, [
					\freq, nextChord[0].midicps;
					\sus, max(duration - 0.4, 0.5);
				]);
				tempo.wait;
			});

			alto = Task({
				Synth(\alto, [
					\freq, nextChord[1].midicps;
					\sus, max(duration - 0.4, 0.5);
				]);
				tempo.wait;
			});

			tenor = Task({
				Synth(\tenor, [
					\freq, nextChord[2].midicps;
					\sus, max(duration - 0.4, 0.5);
				]);
				tempo.wait;
			});

			bass = Task({
				Synth(\bass, [
					\freq, nextChord[3].midicps;
					\sus, max(duration - 0.4, 0.5);
				]);
				tempo.wait;
			});

			soprano.().play(~clock, quant: 1);
			alto.().play(~clock, quant: 1);
			tenor.().play(~clock, quant: 1);
			bass.().play(~clock, quant: 1);

			tempo.wait;

			currentChord = nextChord;

		}
	});
};
)

~chordProg = ['c', 'f', 'g', 'c'];
~t.(~chordProg).play(~clock, quant: 1);

~validNotes = Array.fill(4, 0);

~a = [1, 2, 3];
~a[0] = [1, 2, 3];









