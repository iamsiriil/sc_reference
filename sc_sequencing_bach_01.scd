s.boot;
s.plotTree;

/**************************************************************************************************************
- SEQUENCING BACH 01
**************************************************************************************************************/

// Score
(                                                                                                   // BAR
~evenVoices = List[[                                                                                // Soprano
	[69, 2]   , [nil]     , [nil]     , [nil]     , [62, 2]   , [nil]     , [nil]     , [nil]     , // 1q
	[65, 2]   , [nil]     , [nil]     , [nil]     , [69, 2]   , [nil]     , [nil]     , [nil]     , // 2
	[70, 2]   , [nil]     , [nil]     , [nil]     , [69, 1]   , [nil]     , [67, 1]   , [nil]     , // 3
	[65, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [64, 0.5] , [65, 0.5] , [67, 0.5] , // 4
	[69, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [70, 0.5] , [69, 0.5] , [68, 0.5] , // 5
	[69, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [70, 0.5] , [69, 0.5] , [68, 0.5] , // 6
	[69, 1]   , [nil]     , [74, 1]   , [nil]     , [67, 1]   , [nil]     , [70, 2]   , [nil]     , // 7
	[nil]     , [nil]     , [64, 1]   , [nil]     , [69, 1]   , [nil]     , [67, 2]   , [nil]     , // 8
	[nil]     , [nil]     , [65, 1]   , [nil]     , [70, 3]   , [nil]     , [nil]     , [nil]     , // 9
	[nil]     , [nil]     , [69, 1]   , [nil]     , [74, 3]   , [nil]     , [nil]     , [nil]     , // 10
	[nil]     , [nil]     , [72, 1]   , [nil]     , [70, 3]   , [nil]     , [nil]     , [nil]     , // 11
	[nil]     , [nil]     , [69, 0.5] , [67, 0.5] , [65, 3]   , [nil]     , [nil]     , [nil]     , // 12
	[nil]     , [77, 0.5] , [76, 0.5] , [74, 0.5] , [76, 0.5] , [77, 0.5] , [79, 0.5] , [76, 0.5] , // 13
	[81, 2]   , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [69, 1]   , [nil]     , // 14
	[65, 4]   , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 15
	[64, 1]   , [nil]     , [76, 1]   , [nil]     , [72, 2.5] , [nil]     , [nil]     , [nil]     , // 16
	[nil]     , [72, 0.5] , [71, 0.5] , [69, 0.5] , [71, 0.5] , [73, 0.5] , [74, 1]   , [nil]     , // 17
	[76, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [73, 0.5] , [74, 0.5] , [76, 0.5] , // 18
	[69, 2]   , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]       // 19 / 1

], [                                                                                                // Alto
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 1
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 2
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 3
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 4
	[62, 2]   , [nil]     , [nil]     , [nil]     , [57, 2]   , [nil]     , [nil]     , [nil]     , // 5
	[60, 2]   , [nil]     , [nil]     , [nil]     , [64, 2]   , [nil]     , [nil]     , [nil]     , // 6
	[65, 2]   , [nil]     , [nil]     , [nil]     , [64, 1]   , [nil]     , [62, 1]   , [nil]     , // 7
	[61, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [57, 0.5] , [59, 0.5] , [61, 0.5] , // 8
	[62, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [60, 0.5] , [62, 0.5] , [64, 0.5] , // 9
	[65, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [64, 0.5] , [65, 0.5] , [67, 0.5] , // 10
	[69, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [67, 0.5] , [65, 0.5] , [64, 0.5] , // 11
	[62, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [64, 0.5] , [62, 0.5] , [61, 0.5] , // 12
	[62, 1]   , [nil]     , [65, 1]   , [nil]     , [61, 1]   , [nil]     , [64, 2]   , [nil]     , // 13
	[nil]     , [nil]     , [57, 1]   , [nil]     , [62, 2.5] , [nil]     , [nil]     , [nil]     , // 14
	[nil]     , [63, 0.5] , [62, 0.5] , [61, 0.5] , [62, 1]   , [nil]     , [74, 2]   , [nil]     , // 15
	[nil]     , [nil]     , [72, 0.5] , [71, 0.5] , [69, 0.5] , [67, 0.5] , [65, 0.5] , [64, 0.5] , // 16
	[62, 1]   , [nil]     , [67, 1.5] , [nil]     , [nil]     , [69, 0.5] , [67, 0.5] , [65, 0.5] , // 17
	[67, 0.5] , [69, 0.5] , [70, 0.5] , [67, 0.5] , [64, 4]   , [nil]     , [nil]     , [nil]     , // 18
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]       // 19 / 1

], [                                                                                                // Tenor
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 1
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 2
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 3
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 4
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 5
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 6
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 7
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 8
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 9
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 10
	[57, 2]   , [nil]     , [nil]     , [nil]     , [50, 2]   , [nil]     , [nil]     , [nil]     , // 11
	[53, 2]   , [nil]     , [nil]     , [nil]     , [57, 2]   , [nil]     , [nil]     , [nil]     , // 12
	[58, 2]   , [nil]     , [nil]     , [nil]     , [57, 1]   , [nil]     , [55, 1]   , [nil]     , // 13
	[53, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [52, 0.5] , [53, 0.5] , [55, 0.5] , // 14
	[57, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [58, 0.5] , [57, 0.5] , [56, 0.5] , // 15
	[57, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [58, 0.5] , [57, 0.5] , [56, 0.5] , // 16
	[57, 1]   , [nil]     , [62, 1]   , [nil]     , [55, 1]   , [nil]     , [58, 2]   , [nil]     , // 17
	[nil]     , [nil]     , [52, 1]   , [nil]     , [57, 1]   , [nil]     , [55, 1]   , [nil]     , // 18
	[53, 2]   , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]       // 19 / 1

], [                                                                                                // Bass
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 1
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 2
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 3
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 4
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 5
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 6
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 7
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 8
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 9
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 10
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 11
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 12
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 13
	[nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , // 14
	[50, 2]   , [nil]     , [nil]     , [nil]     , [45, 2]   , [nil]     , [nil]     , [nil]     , // 15
	[48, 2]   , [nil]     , [nil]     , [nil]     , [52, 2]   , [nil]     , [nil]     , [nil]     , // 16
	[53, 2]   , [nil]     , [nil]     , [nil]     , [52, 1]   , [nil]     , [50, 1]   , [nil]     , // 17
	[49, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [45, 0.5] , [47, 0.5] , [49, 0.5] , // 18
	[50, 2]   , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [nil]       // 19 / 1
]];
)

// Synth Definition
(
SynthDef(\tone, {
	arg frq = 440, atk = 0.2, sus = 0.5, rel = 0.3;
	var sig = SinOsc.ar(frq, mul: 0.2) * Env.linen(atk, sus, rel, curve: \sin).ar(Done.freeSelf);
	sig = sig ! 2;
	Out.ar(0, sig);
}).add;
)

// Task Definition
(
~clock = TempoClock.new(180/60);

~taskVoice = {
	arg voiceNotes;

	Task({

		voiceNotes.do { |event, i|
			var voiceDur, voiceDurArr;
			var tempo = 0.5;

			if (event[0] != nil) {
				voiceDur = (event[1] / ~clock.tempo); // + rrand(-0.07, 0.07); // rrand(...) Humanizes rhythm pattern.
				voiceDurArr = [0.2, 0.4, 0.2].breakAndNormalize(voiceDur).postln;

				Synth(\tone, [
					\frq, event[0].midicps,
					\atk, voiceDurArr[0],
					\sus, voiceDurArr[1],
					\rel, voiceDurArr[2]
				]);
			};
			tempo.wait;
		};
	});
};
)

// Playback
(
~taskSpn = ~taskVoice.(~evenVoices[0]).play(~clock, quant: 1);
~taskAlt = ~taskVoice.(~evenVoices[1]).play(~clock, quant: 1);
~taskTen = ~taskVoice.(~evenVoices[2]).play(~clock, quant: 1);
~taskBas = ~taskVoice.(~evenVoices[3]).play(~clock, quant: 1);
)