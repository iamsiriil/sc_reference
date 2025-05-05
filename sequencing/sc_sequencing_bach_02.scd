s.boot;

/**************************************************************************************************************
- SEQUENCING BACH 02
**************************************************************************************************************/

// Load score
(
"./sc_sequencing_bach_01_score.scd".loadRelative;
"../algorithms/sc_queue_00.scd".loadRelative;
)

// Synth Definition
(
SynthDef(\tone, {
	arg frq = 440, atk = 0.2, sus = 0.5, rel = 0.3, pan = 0;
	var sig = SinOsc.ar(frq, mul: 0.2) * Env.linen(atk, sus, rel, curve: \sin).ar(Done.freeSelf);
	sig = sig ! 2;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
// Create score event
~fugueBach = (
	\score: ~score,
	\maxIndex: (~score[0].size - 1),
	\curIndex: 0,
	\endOfScore: false
);

// Create new queue
~q = ~createQueue.(16);

// FillQueue function feeds new events to queue
~fillQueue = { |queue, score|
	var n = if (score[\curIndex] == 0) { queue[\maxSize] } { queue[\maxSize] / 2 };
	var temp, k;

	n.do { |i|
		temp = Array.fill(4, {0});
		k = 0;

		4.reverseDo { |j|
			temp[j] = score[\score][k][(score[\curIndex] + i)];
			k = k + 1;
		};

		 ~enqueue.(queue, temp);
		temp = nil;
	};
	score[\curIndex] = score[\curIndex] + n;

	if (score[\curIndex] == score[\maxIndex]) { score[\endOfScore] = true };
};
)

// Test fillQueue function
(
~fillQueue.(~q, ~fugueBach);
~q[\list][0];
)
