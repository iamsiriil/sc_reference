(
~getChordNoteNameOct = #{ |chord, midiRange, triads|

	chord.collect { |n| midiRange[\octave][n] };
};

)

(
var chords = ~data[\chords];
var prog = ~progState[\progression];
var names = Array.new;

prog.do { |c|
	names = ~triads[c][\names].wrapExtend(~triads[c][\notes].size);
};
~noteNames = ~progState[\result][0].collect { |i| ~midiRange[\octave][i] }.postln;
)
~progState[\result]
~data[\chords]