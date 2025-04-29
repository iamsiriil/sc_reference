s.boot;
s.quit;

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