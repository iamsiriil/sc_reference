(
~currChord = [41, 53, 60, 69]; // F Major
~nextChord = [43, 55, 59, 74]; // G Major with parallele octaves and a 10th between spn and alt
~nextChord02 = [43, 59, 62, 67];
)

67 - 43

(
~checkRange = { |nextChord, i|
	if (i > 0) {
		(nextChord[i] - nextChord[i - 1]) <= 12;
	};
}
)

~checkRange.(~nextChord, 0);

(
~checkParalOct = { |chord|
	var indexArray;
	var octaves = [12, 24, 36, 48, 60];
	var i, j;

	i = 0;
	for (i, 2) {

		j = i + 1;
		for (j, 3) {

			octaves.do { |oct|

				if ((chord[j] - chord[i]) == oct) {
					indexArray = [i, j];
				};
			};
		};
	};
	indexArray;
};
)

~checkParalOct.(~nextChord02)

(
var item;
item
)