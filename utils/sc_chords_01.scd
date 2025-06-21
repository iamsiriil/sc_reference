(
~progression = Dictionary[
	\key -> "CM",
	\chords -> Dictionary[
		0 -> Dictionary[
			\cipher -> "CM",
			\root -> "C",
			\type -> "M",
			\degree -> "I"
			\isDiatonic -> true,
			\dissonance = [],
			\repeat -> 0
		];
	];
];
)

(
~midiRange = (0..127);
~midiFirstOctave = (0..11);
~root = 0;

~scaleDegrees = [0, 2, 4, 5, 7, 9, 11];
~noteNames = ["C", "D", "E", "F", "G", "A", "B"];
)
(
~scale = ((~scaleDegrees + 6).collect { |n| ~midiFirstOctave.wrapAt(n) }).sort;

~scale.do { |n, i|
	if (n != ~scaleDegrees[i]) {
		case
		{ n >  ~scaleDegrees[i]} {
			var noteName = ~noteNames[i];

			((n - ~scaleDegrees[i]).abs).do {

				noteName = noteName ++ "#";
			};
			noteName.postln;
		}
		{ n <  ~scaleDegrees[i]} {
			var noteName = ~noteNames[i];

			((n - ~scaleDegrees[i]).abs).do {

				noteName = noteName ++ "b";
			};
			noteName.postln;
		}
	} {
		~noteNames[i].postln;
	}
}


)