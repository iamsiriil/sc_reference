s.boot;
s.quit;

(
~bufs = ();
~path = PathName.new("./../../soundbank/drums/".resolveRelative);
Buffer.read(s, ~path.entries[2].entries[2].fullPath, action: { |buf|
	~bufs[\kd] = buf;
});
Buffer.read(s, ~path.entries[0].entries[0].fullPath, action: { |buf|
	~bufs[\cl] = buf;
});
)

Buffer.freeAll;

(
SynthDef(\drums, { |bufnum = 0|
	var pbuf = PlayBuf.ar(1, bufnum);
	Out.ar(0, Pan2.ar(pbuf, 0));
}).add;
)

(
SynthDef(\tone, { |freq = 400|
	var modFreq = 220;
	var modIndex = Rand(20, 40);
	var detune = Rand(-0.5, 0.5);
	var mod = SinOsc.ar(modFreq, 0, modIndex);
	var sig = SinOsc.ar((freq + detune) + mod);
	sig = sig * XLine.kr(0.3, 0.01, 5, doneAction: 2);
	sig = FreeVerb.ar(sig, 0.3, 0.8, 0.5);
	sig = Limiter.ar(sig, 0.95);
	sig = sig ! 2;
	Out.ar(0, Pan2.ar(sig, Rand(-1, 1)));
}).add;
)

(
SynthDef(\cello, {
	|freq = 220, amp = 0.4, gate = 1|
	var vibrato = SinOsc.kr(5, 0, 0.01, 1);
	var sig = LFSaw.ar(freq * vibrato, 0, 0.5);
	sig = LPF.ar(sig, freq * 3);
	sig = sig * EnvGen.kr(Env.adsr(0.5, 0.3, 0.5, 2), gate, doneAction: 2);
	sig = sig * amp;
	sig = FreeVerb.ar(sig, 0.3, 0.8, 0.5);
	Out.ar(0, sig ! 2);
}).add;
)

(
~t_harm = { |tonic = \e|
	var baseNotes = [48, 52, 54, 55, 59, 60, 64, 66, 67, 71];
	var transpose = if( tonic == \e ) { 0 } { 5 };
	var notes = baseNotes + transpose;

	Task({
		loop {
			Synth(\tone, [\freq, notes.choose.midicps]);
			[0.5, 1, 1.5, 2].choose.wait;
		}
	});
}
)

(
~t_drum = Task({
	loop {
		Synth(\drums, [\bufnum, ~bufs[\kd].bufnum]);
		1.5.wait;
		Synth(\drums, [\bufnum, ~bufs[\kd].bufnum]);
		0.5.wait;
		Synth(\drums, [\bufnum, ~bufs[\cl].bufnum]);
		2.wait;
	}
});
)

(
~celloPhrase = Pxrand([
	/*Pmono(\cello,
		\midinote, Pseq([40, 45, 47, 48, 48, 45, 43, 42, 40], 1),
		\dur, Pseq([6, 2, 6, 2, 2, 2, 2, 2, 8], 1),
		\amp, 0.9
	),
	Pmono(\cello,
		\midinote, Pseq([40, 42, 43, 47, 40], 1),
		\dur, Pseq([8, 8, 16, 8, 16], 1),
		\amp, 0.9
	),*/
	Pmono(\cello,
		\midinote, Pseq([40, 40, 36, 40], 1),
		\dur, Pseq([16, 16, 16, 16], 1),
		\amp, 0.9
	)
], inf);
)

(
~clock = TempoClock.new(100/60);

~t_harm.(\e).play(~clock, quant: 1);
~celloPhrase.play(~clock, quant: 1);
~t_drum.play(~clock, quant: 1);
)

