s.boot;

s.plotTree;
s.scope(2);

/**************************************************************************************
- PLAINCHANT 03
- Purpose:
  A small exercise in rule-based melodic generation, simulating plainchant.
- Logic:
  * Random melodic motion within a predefined note range.
  * Steps are biased toward smaller intervals using weighted choices.
  * Custom rules prevent specific undesired note transitions.
  * A low continuous "pedal" tone runs underneath the melodic line.
  * Generates multiple phrases, with special handling for the first and last notes.
**************************************************************************************/


(
SynthDef(\tone, { |freq = 440, sus = 1|
	var snd = SinOsc.ar(freq) * Env.linen(0.1, sus, 0.3, 0.4, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
SynthDef(\pedal, { |freq = 220, sus = 1|
	var snd = SinOsc.ar(freq) * Env.linen(0.1, sus, 0.3, 0.2, \sin).ar(Done.freeSelf);
	Out.ar(0, snd ! 2);
}).add;
)

(
~nextIndexIsValid = { |currentIndex, nextIndex, notes|
	case
	{ (nextIndex < 0) || (nextIndex > (notes.size - 1)) } { false }
	{ (notes[currentIndex] == 65) && (notes[nextIndex] == 71) } { false }
	{ (notes[currentIndex] == 71) && ((notes[nextIndex] == 65) || (notes[nextIndex] == 77)) } { false }
	{ (notes[currentIndex] == 77) && (notes[nextIndex] == 71) } { false }
	{ true }
};
)

(
~clock = TempoClock.new(100/60);

~t = { |numPhrases = 3|
	Task({
		var notes = [65, 67, 69, 71, 72, 74, 76, 77, 79, 81];
		var intervals = [0, 1, 2, 3, 4];
		var intervCount = [29, 150, 41, 4, 5];
		var intervWeight = intervCount.normalizeSum;

		var currentIndex = notes.indexOf(74);

		~pedalTask = Task({
			var tempo = 4;
			var duration = (tempo / ~clock.tempo);
			loop {
				Synth(\pedal, [\freq, 55.midicps, \sus, max((duration - 0.4), 0.5)]);
				tempo.wait;
			}
		});
		~pedalTask.play(~clock, quant: 1);

		numPhrases.do { |p|
			var notesInPhrase = rrand(30, 40);
			("Phrase #" ++ p).postln;


			notesInPhrase.do { |n|
				var nextIndex = currentIndex + (intervals.wchoose(intervWeight) * [-1, 1].choose);

				var tempo = [0.5, 1].choose;
				var duration = tempo / ~clock.tempo;
				("Note #" ++ n).post;

				case (
					{ (p == 0) && (n == 0) }, { nextIndex = notes.indexOf(74); " | First note".postln },
					{ (p == (numPhrases - 1)) && (n == (notesInPhrase - 1)) }, { nextIndex = notes.indexOf(67); duration = 2; "| Last note".postln },
					{
						"| Middle note".postln;
						while { (~nextIndexIsValid.(currentIndex, nextIndex, notes)).not } {
							(nextIndex + ": Not valid").postln;
							nextIndex = currentIndex + (intervals.wchoose(intervWeight) * [-1, 1].choose);
						}
					}
				);

				("Current note:" + notes[currentIndex] + "| Next index:" + nextIndex).postln;


				Synth(\tone, [
					\freq, notes[nextIndex].midicps,
					\sus, max(duration - 0.4, 0.01)
				]);
				tempo.wait;

				currentIndex = nextIndex;
			}
		};

		~pedalTask.stop;

	});
};
)

~t.(2).play(~clock, quant: 1);
