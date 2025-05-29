Tonal {
	var <>key;

	*new { |key|
		^super.new.init(key)
	}
}

ChordType : Tonal {
	var triads;

	*new { |key, chord|
		^super.new.init;
	}

	init {
		var triads = IdentityDictionary[
			\M -> [0, 4, 7],
			\m -> [0, 3, 7],
			\d -> [0, 3, 6],
			\A -> [0, 4, 8]
		];

		var seventh = IdentityDictionary[
			\M7 -> [0, 4, 7, 11],
			\7 -> [0, 4, 7, 10],
			\m7 -> [0, 3, 7, 10],
			\d7 -> [0, 3, 6, 10],
			\7d5 -> [0, 3, 6, 9]
		];
	}
}