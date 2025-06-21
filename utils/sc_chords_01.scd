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
~scaleDegrees_m = [0, 2, 3, 5, 7, 8, 10];
~noteNames = ["C", "D", "E", "F", "G", "A", "B"];

)
(
~scale = ((~scaleDegrees + 7).collect { |n| ~midiFirstOctave.wrapAt(n) }).sort;

~newScale = Array.new(7);

~scale.do { |n, i|
	if (n != ~scaleDegrees[i]) {
		case
		{ n >  ~scaleDegrees[i]} {
			var noteName = ~noteNames[i];

			((n - ~scaleDegrees[i]).abs).do {

				noteName = noteName ++ "#";
			};
			noteName.postln;
			~newScale.add(noteName.copy);
		}
		{ n <  ~scaleDegrees[i]} {
			var noteName = ~noteNames[i];

			((n - ~scaleDegrees[i]).abs).do {

				noteName = noteName ++ "b";
			};
			noteName.postln;
			~newScale.add(noteName.copy);
		}
	} {
		~noteNames[i].postln;
		~newScale.add(~noteNames[i].copy);
	}
}
)
(
~root = 7;

~diatChords = [
	[0, 4, 7],
	[2, 5, 9],
	[4, 7, 11],
	[5, 9, 12],
	[7, 11, 14],
	[9, 12, 16],
	[11, 14, 17]
];

~triads = Array.new(7);

(~diatChords + ~root).do { |c|
	var arr = Array.new(3);

	arr = c.collect { |n|
		~midiFirstOctave.wrapAt(n)
	};
	~triads.add(arr.copy);
};

~triads;
)

~diatChords + 7

~arr = [0, 2, 4, 6, 7, 9, 11];

~newScale
~scale.indexOf(6)

(
~triadsGM = Array.new(7);

~triads.do { |c|
	var arr = Array.new(3);

	c.collect { |n|
		arr.add(~newScale[~scale.indexOf(n)])
	};
	~triadsGM.add(arr);
};

)
~triadsGM













