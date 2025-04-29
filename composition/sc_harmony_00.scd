s.boot;
s.quit;

/**************************************************************************************
- HARMONY 00
- Four-voice chord progression generator with backtracking for C, Dm, Em, F, G, Am triads.
- Features: Hard-coded diatonic chord ranges, reuse lastValidNextChords for repeated chords,
  static state (~chordState), voice ranges (bass: E2–C4, tenor: C3–G4, alto: G3–D5,
  soprano: C4–A5), no voice crossing, simplified voice leading (all voices: unisons, steps,
  3rds, 4ths, 5ths). Pulse.ar SynthDef, 100 BPM, 0.8s sustain. Includes generated first
  chord for flexibility.
- Prepares for HARMONY 01 (dynamic triad generation, stricter voice-leading, doubling rules).
**************************************************************************************/

(
SynthDef(\pulsetone, { |freq = 440, atk = 0.2, sus = 0.5, rel = 0.3|
	var snd = Pulse.ar(freq, 0.1) * Env.linen(atk, sus, rel, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
~chordState = (
	chords: (
			'c': [40, 43, 48, 52, 55, 60, 64, 67, 72, 76, 79], // C Major: C E G
			'd': [41, 45, 50, 53, 57, 62, 65, 69, 74, 77, 81], // D minor: D F A
			'e': [40, 43, 47, 52, 55, 59, 64, 67, 71, 76, 79], // E minor: E G B
 			'f': [41, 45, 48, 53, 57, 60, 65, 69, 72, 77, 81], // F Major: F A C
			'g': [43, 47, 50, 55, 59, 62, 67, 71, 74, 79],     // G Major: G B D
			'a': [40, 45, 48, 52, 57, 60, 64, 69, 72, 76, 81]  // A minor: A C E
	),
	lastChord: nil,
	lastValidNextChords: nil
);
~rangeIsValid = IdentityDictionary[
	\spn -> { |note| (note >= 60) && (note <= 81) }, // C4-A5
	\alt -> { |note| (note >= 55) && (note <= 74) }, // G3-D5
	\ten -> { |note| (note >= 48) && (note <= 67) }, // C3-G4
	\bas -> { |note| (note >= 40) && (note <= 60) }  // E2-C4
];

~checkVoiceCross = { |lowerNote, higherNote| (lowerNote < higherNote) };

~noteIsValid = {
	arg nextChord, i;

	case
	{ i == 0 } {
		~rangeIsValid[\bas].(nextChord[i]);
	}
	{ i == 1 } {
		~rangeIsValid[\ten].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
	}
	{ i == 2 } {
		~rangeIsValid[\alt].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
	}
	{ i == 3 } {
		~rangeIsValid[\spn].(nextChord[i]) && ~checkVoiceCross.(nextChord[i - 1], nextChord[i]);
	};
};

~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getNextChords = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid;

	if (i == numVoices) {
		validNextChords.add(nextChord.copy);
	} {
		validNotes[i].do { |note|

			nextChord.put(i, note);

			isValid = ~noteIsValid.(nextChord, i);
			if (isValid) {
				~getNextChords.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
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
		var currentChord = [48, 55, 64, 72];
		var validNextChords;

		var tempo = 2;
		var duration = tempo / ~clock.tempo;
		var envDurations = [0.1, 0.6, 0.3].breakAndNormalize(duration).collect(_.clip(0.01, 5.0));

		chordProg.do { |c, i|
			var validNotes = Array.fill(4, {[]});
			var nextChord = Array.fill(4, {0});
			var buildChord = Array.fill(4, {0});
			var voices = [\bas, \ten, \alt, \spn];

			case
			{ i == 0 } { nextChord = currentChord }
			{ (i > 0) && (c == chordProg[i - 1]) } {
				nextChord = ~chordState[\lastValidNextChords].choose ?? { currentChord };
			}
			{
				4.do { |j|
					validNotes[j] = ~getValidNotes.(~chordState[\chords][c].select(~rangeIsValid[voices[j]]), currentChord[j]);
				};
				"Valid Notes: %".format(validNotes).postln;
				validNextChords = Array.new(10);
				~getNextChords.(currentChord.size, buildChord, validNextChords, validNotes, 0);
				~chordState[\lastValidNextChords] = validNextChords;
				nextChord = validNextChords.choose ?? { currentChord }; // Defaults to current chord if validNextChord is nil.
				validNextChords = nil;
				validNotes = nil;
			};

			nextChord.do { |note, voiceIndex|
				Synth(\pulsetone, [
					\freq, note.midicps,
					\atk, envDurations[0],
					\sus, envDurations[1],
					\rel, envDurations[2]
				]);
			};
			tempo.wait;

			currentChord = nextChord;
		};
	});
};

~chordProg = ['c', 'f', 'a', 'e', 'g', 'c', 'd', 'f', 'g', 'c'];
~t.(~chordProg).play(~clock, quant: 1);
)


