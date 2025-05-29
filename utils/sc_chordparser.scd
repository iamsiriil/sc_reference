//Chord parser
(
~c = "C#Maj7+9/E#";
~chordData = Dictionary[
	\root -> nil,
	\bass -> nil,
	\seventh -> nil,
	\extensions -> nil
];
~parser = { |cipher|
	var bass = nil;

	if (cipher.contains($/)) {
		#cipher, bass = cipher.split($/);
		~chordData[\bass] = bass;
	};

	if ((cipher[1] == $#) || (cipher[1] == $b)) {
		~chordData[\root] = cipher[0..1];
		cipher = cipher.drop(2);
	} {
		~chordData[\root] = cipher[0];
		cipher = cipher.drop(1);
	};

	if (~chordData[\bass] == nil) {
		~chordData[\bass] = ~chordData[\root];
	};

	if (cipher.notEmpty && cipher.contains($7)) {
		~chordData[\seventh] = cipher[0..(cipher.indexOf($7))];
		cipher = cipher.drop(cipher.indexOf($7) + 1).postln;
	};

	if (cipher.notEmpty && cipher.contains($9)) {
		var ext = Array.new(7);
		ext.add(cipher[0..(cipher.indexOf($9))]);
		~chordData[\extension] = ext;
	}
};
~parser.(~c);

~chordData;
)
~c[1] == $#
if (~c.contains($7)) { ~c[0..~c.indexOf($7)] }
~c.drop(~c.indexOf($7) + 1)
"a".isEmpty