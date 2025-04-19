
s.boot;
s.quit;

/*************************************************************************************************/

{ SinOsc.ar(XLine.kr(2000, 200, 10), 0, 0.5) ! 2 }.play;

/*
-> Basic frequency sweep.
-> SinOsc.ar generates a tone whose frequency is controlled by XLine.kr — a control-rate ramp from 2000 Hz to 200 Hz over 10 seconds.
-> The glide effect is smooth, though the frequency control signal is updated only at control rate (every few samples), which is fine for gradual changes.
-> Phase is fixed at 0, amplitude is set via the mul argument to 0.5.
-> The ! 2 duplicates the signal into stereo.
*/

{ SinOsc.ar(SinOsc.ar(XLine.kr(1, 1000, 9), 0, 200, 800), 0, 0.25) ! 2 }.plot;

/*
-> More complex frequency modulation.
-> Outer SinOsc.ar's frequency is controlled by an inner SinOsc.ar, which itself is modulated by an XLine.kr ramping from 1 Hz to 1000 Hz over 9 seconds.
-> The inner SinOsc is scaled by mul: 200 and offset by add: 800, so the modulated frequency oscillates between 600 and 1000 Hz.
-> This creates a perceived up-down gliding effect (vibrato-like), with the glide becoming faster as the XLine increases — due to shorter sine wave cycles.
-> All modulating signals use .ar to ensure **sample-accurate modulation**, essential for clean FM behavior. Using .kr here would result in noticeable stepping or glitchiness.
-> Phase is 0, final amplitude is 0.25, and the output is duplicated in stereo.
*/

{ SinOsc.ar(800, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25) ! 2 }.play;

/*
-> Demonstrates phase modulation.
-> Carrier SinOsc.ar is at 800 Hz.
-> Phase input is another SinOsc.ar, whose frequency increases from 1 Hz to 1000 Hz over 9 seconds via XLine.kr.
-> The inner SinOsc is scaled to have an amplitude of 2π (a full phase cycle), making it a proper modulator for the carrier's phase.
-> This causes a tremolo-like effect, where perceived amplitude fluctuates due to constructive/destructive interference — depending on phase alignment.
-> The inner SinOsc uses .ar to ensure smooth phase transitions; .kr would lead to stepping and a less fluid modulation.
-> Final amplitude is 0.25, and signal is duplicated to stereo.
*/

