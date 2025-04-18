s.boot;
s.plotTree;

x = { var delta; loop { delta = rrand(1, 3) * 0.5; ("Will wait" + delta).postln; delta.yield; } }.r;

x.next;

TempoClock.default.sched(0, x);

x.stop;

// Defining a Synth

(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1, out|
	var sig;
	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2);
}).add;
)

// Invoking the Synth from a Routine

(
r = Routine {
	var delta;
	loop {
		delta = rrand(1, 3) * 0.5;
		Synth(\singrain, [freq: exprand(200, 800), amp: rrand(0.1, 0.5), sustain: delta * 0.8]);
		delta.yield;
	}
};
)

r.play;
r.stop;

// Invoking the Synth from a Task. Contrary to the routine,
// the task allows us to stop and resume a scheduled sequence.

(
t = Task({
	loop {
		[60, 62, 64, 65, 67, 69, 71, 72].do ({ |midi|
			Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
			0.25.wait;
		});
	}
});
)

~clock = TempoClock.new(120/60);

// the variable '~clock' can be used to communicate to
// the routine/task, to which clock it should synch to.

t.play(~clock, doReset: true); // doReset resets the sequence to the beginning.
t.stop;
t.start;

// A task is defined inside a function, which is then used to manipulte the task.

(
f = {
	Task({
		loop {
			[60, 62, 64, 65, 67, 69, 71, 72].do ({ |midi|
				Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
				0.25.wait;
			});
		}
	});
}
)

~clock = TempoClock.new(60/60);

f.value;
t = f.value.play(quant: 4);
u = f.value.play(quant: [4, 0.5]);

t.stop; u.stop;











