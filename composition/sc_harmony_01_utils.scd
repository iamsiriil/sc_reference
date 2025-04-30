/**************************************************************************************
- HARMONY 01

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
)