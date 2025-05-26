s.boot;

(
SynthDef(\granularPerc, {
    var env, grains, snd;
    env = Env.perc(0.01, 0.5).kr(doneAction: 2);
    grains = GrainSin.ar(
        numChannels: 1,
        trigger: Dust.ar(100),
        dur: 0.05,
        freq: Rand(200, 2000),
        pan: 0,
        mul: env
    );
    snd = grains * 0.3;
    Out.ar(0, snd ! 2);
}).add;
)

Synth(\granularPerc);