s.boot;

(
SynthDef(\snareRollRealistic, { |rate=15, decay=0.7|
    var trig = Impulse.ar(rate);
    var exciter = PinkNoise.ar(Decay2.ar(trig, 0.01, 0.05));
    var snd = Klank.ar(
        `[
            [200, 400, 800, 1200], // Resonant freqs
            [0.3, 0.2, 0.1, 0.05],  // Amplitudes
            [0.5, 0.5, 0.3, 0.2]    // Decay times
        ],
        exciter
    );
    snd = snd * Decay.ar(trig, decay);
    Out.ar(0, snd ! 2);
}).add;
)

Synth(\snareRollRealistic, [\rate, 20, \decay, 1.0]);