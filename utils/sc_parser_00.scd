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

~parser = { |prog|
	prog.do { |c, i|
		var dict = Dictionary.new;

		dict[\cipher] = c;
		dict[\type] = c.asString.last;

		if (c.asString.size == 3) {
			dict[\root] = c.asString[0..1];
		} {
			dict[\root] = c.asString[0];
		};
		~chords[i] = dict;
	}
};

~parser.(~prog);
)
~chords[1]
'CM'.asString.last