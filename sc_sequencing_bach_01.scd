s.boot;
s.plotTree;

/**************************************************************************************************************
- SEQUENCING BACH 01
**************************************************************************************************************/

// Load score
"./sc_sequencing_bach_01_score.scd".loadRelative;

// Synth Definition
(
SynthDef(\tone, {
	arg frq = 440, atk = 0.2, sus = 0.5, rel = 0.3, pan = 0;
	var sig = SinOsc.ar(frq, mul: 0.2) * Env.linen(atk, sus, rel, curve: \sin).ar(Done.freeSelf);
	sig = sig ! 2;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

// Task Definition
(
~clock = TempoClock.new(180/60);

~taskVoice = {
	arg voiceNotes, pan;

	Task({


		voiceNotes.do { |event, i|
			var voiceDur, voiceDurArr;
			var tempo = 0.5;

			if (event != nil) {
				voiceDur = (event[1] / ~clock.tempo);
				voiceDurArr = [0.2, 0.4, 0.2].breakAndNormalize(voiceDur);

				Synth(\tone, [
					\frq, event[0].midicps,
					\atk, voiceDurArr[0],
					\sus, voiceDurArr[1],
					\rel, voiceDurArr[2],
					\pan, pan
				]);
			};
			tempo.wait;
		};
	});
};
)

// Playback
(8
~taskSpn = ~taskVoice.(~score[0], 0.9).play(~clock, quant: 1);
~taskAlt = ~taskVoice.(~score[1], 0.3).play(~clock, quant: 1);
~taskTen = ~taskVoice.(~score[2], -0.3).play(~clock, quant: 1);
~taskBas = ~taskVoice.(~score[3], -0.9).play(~clock, quant: 1);
)