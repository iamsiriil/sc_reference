(
SynthDef(\woodblock, {
    var env, snd;
    env = Env.perc(0.01, 0.1, 0.5, -8).kr(doneAction: 2);
    snd = Klank.ar(
        `[
            [500, 1200, 3000],  // frequencies
            [0.3, 0.1, 0.05],   // amplitudes
            [0.5, 0.3, 0.2]     // ring times
        ],
        Impulse.ar(0) * env
    );
    Out.ar(0, snd ! 2);
}).add;
)

Synth(\woodblock);