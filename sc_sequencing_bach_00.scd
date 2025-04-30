s.boot;
s.plotTree;

/**************************************************************************************************************
- SEQUENCING BACH 00
**************************************************************************************************************/

(
~evenSpn_00 = List[                                                                                 // BAR
	[69, 2]   , [nil]     , [nil]     , [nil]     , [62, 2]   , [nil]     , [nil]     , [nil]     , // 1
	[65, 2]   , [nil]     , [nil]     , [nil]     , [69, 2]   , [nil]     , [nil]     , [nil]     , // 2
	[70, 2]   , [nil]     , [nil]     , [nil]     , [69, 1]   , [nil]     , [67, 1]   , [nil]     , // 3
	[65, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [64, 0.5] , [65, 0.5] , [67, 0.5] , // 4
	[69, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [70, 0.5] , [69, 0.5] , [68, 0.5] , // 5
	[69, 2.5] , [nil]     , [nil]     , [nil]     , [nil]     , [70, 0.5] , [69, 0.5] , [68, 0.5] , // 6
	[69, 1]   , [nil]     , [74, 1]   , [nil]     , [65, 1]   , [nil]     , [70, 2]   , [nil]       // 7
];

/*[ // Soprano (...)
	[69, 1]   , [nil]     , [74, 1]   , [nil]     , [65, 1]   , [nil]     , [70, 2]   , [nil]     , // 7
	[nil]     , [nil]     , [64, 1]   , [nil]     , [69, 1]   , [nil]     , [67, 2]   , [nil]     , // 8
	[nil]     , [nil]     , [65, 1]   , [nil]     , [70, 3]   , [nil]     , [nil]     , [nil]     , // 9
	[nil]     , [nil]     , [69, 1]   , [nil]     , [74, 3]   , [nil]     , [nil]     , [nil]     , // 10
	[nil]     , [nil]     , [72, 1]   , [nil]     , [70, 3]   , [nil]     , [nil]     , [nil]     , // 11
	[nil]     , [nil]     , [69, 0.5] , [67, 0.5] , [65, 3]   , [nil]     , [nil]     , [nil]     , // 12
	[nil]     , [77, 0.5] , [76, 0.5] , [74, 0.5] , [76, 0.5] , [77, 0.5] , [79, 0.5] , [76, 0.5] , // 13
	[81, 2]   , [nil]     , [nil]     , [nil]     , [nil]     , [nil]     , [69, 1]   , [nil]       // 14
];*/

~evenAlt_00 = List[
	[nil]     , [nil]    , [nil]     , [nil]    , [nil]    , [nil]     , [nil]     , [nil]      , // 1
	[nil]     , [nil]    , [nil]     , [nil]    , [nil]    , [nil]     , [nil]     , [nil]      , // 2
	[nil]     , [nil]    , [nil]     , [nil]    , [nil]    , [nil]     , [nil]     , [nil]      , // 3
	[nil]     , [nil]    , [nil]     , [nil]    , [nil]    , [nil]     , [nil]     , [nil]      , // 4
	[62, 2]   , [nil]    , [nil]     , [nil]    , [57, 2]  , [nil]     , [nil]     , [nil]      , // 5
	[60, 2]   , [nil]    , [nil]     , [nil]    , [64, 2]  , [nil]     , [nil]     , [nil]      , // 6
	[65, 2]   , [nil]    , [nil]     , [nil]    , [64, 1]  , [nil]     , [62, 1]   , [nil]        // 7
];
)

(
SynthDef(\tone, {
	arg frq = 440, atk = 0.2, sus = 0.5, rel = 0.3;
	var sig = SinOsc.ar(frq, mul: 0.2) * Env.linen(atk, sus, rel, curve: \sin).ar(Done.freeSelf);
	sig = sig ! 2;
	Out.ar(0, sig);
}).add;
)

(
~clock = TempoClock.new(160/60);

~taskVoice = { |voiceNotes|
	Task({
		voiceNotes.do { |dt, i|
			var voiceDur, voiceDurArr;
			var tempo = 0.5;

			if (dt[0] != nil) {
				voiceDur = dt[1] / ~clock.tempo;
				voiceDurArr = [0.1, 0.4, 0.2].breakAndNormalize(voiceDur).postln;

				Synth(\tone, [
					\frq, dt[0].midicps,
					\atk, voiceDurArr[0],
					\sus, voiceDurArr[1],
					\rel, voiceDurArr[2]
				]);
				tempo.wait;
			} {
				tempo.wait;
			};
		};
	});
};
~taskSpn = ~taskVoice.(~evenSpn_00).play(~clock, quant: 1);
~taskAlt = ~taskVoice.(~evenAlt_00).play(~clock, quant: 1);
)