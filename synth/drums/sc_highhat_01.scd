s.boot;

(
SynthDef(\hihat, {
    var env = Env.perc(0.01, 0.05).kr(doneAction: 2);
    var snd = HPF.ar(WhiteNoise.ar(env), 10000);
    Out.ar(0, snd ! 2);
}).add;
)

// Hi-hat roll (machine-gun style)
(
Pbind(
    \instrument, \hihat,
    \dur, Pseq([0.0625, 0.0625, 0.0625, 0.0625, 0.03125, 0.03125, 0.03125, 0.03125], inf),
    \amp, 0.3
).play(TempoClock(120 * 4 / 60));
)