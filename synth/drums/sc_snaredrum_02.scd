(
SynthDef(\snare, {
    var env, noise, tone, snd;
    env = Env.perc(0.01, 0.1).kr(doneAction: 2);
    noise = WhiteNoise.ar(env * 0.5);
    tone = SinOsc.ar(180 * (env ** 2) + 50, 0, env * 0.3);
    snd = noise + tone;
    Out.ar(0, snd ! 2);
}).add;
)

// Play a snare roll
(
Pbind(
    \instrument, \snare,
    \dur, Pseq([0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.0625, 0.0625], inf),
    \legato, 0.5 // Short notes
).play(TempoClock(120 * 4 / 60)); // 120 BPM (adjust as needed)
)
