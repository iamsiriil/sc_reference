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
~prog = ['Am', 'Dm', 'FM', 'Bd', 'G#d', 'Am'];
~chords = Dictionary.new;

~midiRoot = { |str|
	var midi = 0;

	~noteNames.do { |n, i|

		if ((str.size == 1) && (n.size == 1) && (n.contains(str))) {
			midi = i;
		};
		if ((str.size > 1) && (n.size > 1) && (n.contains(str))) {
			midi = i;
		};
	};
	midi;
};

~rootDistance = { |prog, chords|
	var arr = Array.new(prog.size);

	arr.add(0);

	for (0, (prog.size - 2)) { |i|
		var f = 0, s = 0;

		f = ~midiRoot.(chords[i][\root].asString);
		s = ~midiRoot.(chords[i + 1][\root].asString);

		if (s > f) {
			arr.add(s - f);
		} {
			s = s + 12;
			arr.add(s - f);
		}
	};

	arr.do { |n, i|
		chords[i][\distance] = n;
	};
	chords;
};

~progParser = { |prog, chords|
	var arr;

	prog.do { |c, i|
		var dict = Dictionary.new;

		dict[\cipher] = c;
		dict[\type] = c.asString.last;

		if (c.asString.size == 3) {
			dict[\root] = c.asString[0..1];
		} {
			dict[\root] = c.asString[0];
		};
		chords[i] = dict;
	};

	~rootDistance.(prog, chords);
};

~dict = ~progParser.(~prog, ~chords);
)










