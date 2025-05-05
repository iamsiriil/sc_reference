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

~clock = TempoClock.new(180/60);

~t = { |queue, score|

	Task({
		var chord, tempo = 2.5;
		var dur, durArray;

		while { score[\endOfScore] == false } {

			~fillQueue.(queue, score);

			while { queue[\list].size > 8 } {

				chord = ~dequeue.(queue);

				~spn = Task({
					if (chord[3] != nil) {
						dur = chord[3][1] / ~clock.tempo;
						durArray = [0.2, 0.5, 0.3].breakAndNormalize(dur);

						Synth(\tone, [
							\freq, chord[3][0].midicps,
							\atk, durArray[0],
							\sus, durArray[1],
							\rel, durArray[2]
						]);
					};
					tempo.wait;
				});
				~alt = Task({
					if (chord[2] != nil) {
						dur = chord[2][1] / ~clock.tempo;
						durArray = [0.2, 0.5, 0.3].breakAndNormalize(dur);

						Synth(\tone, [
							\freq, chord[2][0].midicps,
							\atk, durArray[0],
							\sus, durArray[1],
							\rel, durArray[2]
						]);
					};
					tempo.wait;
				});
				~ten = Task({
					if (chord[1] != nil) {
						dur = chord[1][1] / ~clock.tempo;
						durArray = [0.2, 0.5, 0.3].breakAndNormalize(dur);

						Synth(\tone, [
							\freq, chord[1][0].midicps,
							\atk, durArray[0],
							\sus, durArray[1],
							\rel, durArray[2]
						]);
					};
					tempo.wait;
				});
				~bas = Task({
					if (chord[0] != nil) {
						dur = chord[0][1] / ~clock.tempo;
						durArray = [0.2, 0.5, 0.3].breakAndNormalize(dur);

						Synth(\tone, [
							\freq, chord[0][0].midicps,
							\atk, durArray[0],
							\sus, durArray[1],
							\rel, durArray[2]
						]);
					};
					tempo.wait;
				});

				~spn.play(~clock);
				~alt.play(~clock);
				~ten.play(~clock);
				~bas.play(~clock);
				tempo.wait;

			};
		};
	});
}
)


~t.(~q, ~fugueBach).play(~clock);

