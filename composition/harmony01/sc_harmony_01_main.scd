s.boot;
s.quit;

// Load project files
(
"./sc_harmony_01_utils.scd".loadRelative;
"./sc_harmony_01_tests.scd".loadRelative;
"./sc_harmony_01_lib.scd".loadRelative;
)
/**************************************************************************************
- HARMONY 01 / Main

GOALS:
- Prohibit parallel fifths and octaves between voices
- Enforce root doubling (two roots, one 3rd, one 5th)
- Prioritize root position or 1st inversion, avoid 2nd inversion except in cadential or passing contexts
- Limit voice-leading intervals per voice
    - bass: unisons, 2nds, 3rds, 4ths, 5ths, octaves;
    - tenor/alto: unisons, 2nds, 3rds, 4ths;
    - soprano: unisons, 2nds, 3rds, 4ths, 6ths)
- Fallback system if no valid chord found:
    - equalize root and 1st inversion,
    - allow 2nd inversion,
    - allow non-standard doubling (e.g., two 3rds or two 5ths),
    - relax interval limits, reuse current chord
- Generate first chord dynamically
- Use PBind instead of Task for event-driven playback
- Accept chords and durations as input [['c', 2], ['f', 1], ['g', 1], ['c', 4]], with durations in beats
- getNextChord returns only the first valid chord to reduce computational overhead
**************************************************************************************/

// -> SynthDef

// -> Chord manager structure
(
~chordState = Dictionary({
	\currChord->Array.new();
	\nextChord->Array.new();
	\chordList->Dictionary.new();
	\validNotes->
	\validChords->
});
)

(
~clock = TempoClock.new(120/60);

~t = { |chordProg, firstChord = nil|
	var nextChord, chordList

	// 1. Get all necessary chords for chordProg
	chordList = ~getChords.(chordProg);

	// 2. Check whether a first chord was passed as argument
	//    if not, generate first chord
	if (firstChord != nil) {
		nextChord = fistChord
	} {
		nextChord = ~generateChord.(chordProg[0], chordList);
	};

	// 3. Initiate task
	Task({
	var tempo = 2.5;

		chordProg.do({ |c, i|

			// 3.1. If i == 0, send next chord to play
			if (i == 0) {
				nextChord;
			} {
				// else get valid notes and send to ~getNextChords

				// -> Get valid notes
				// -> Map chord degrees
				// -> Assert whether there are common tones
				//        -> If so, flag corresponding voices
				~getNextChords.(currChord, nextChord, validNotes, 0);
			};

			// Play SATB
			Synth();
			Synth();
			Synth();
			Synth();
			tempo.wait;

			currChord = nextChord;
		});

	});
};
)
































