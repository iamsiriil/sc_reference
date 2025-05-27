(
// Sets chord root in first octave
~root = 7;
// Chord intervals as offset
~chordOffset = [0, 4, 7, 10];
// First octave in midi numbers
~firstOct = (0..11);
// Returns the chord notes for the given root in the first octave
~chord = (~chordOffset + ~root).collect { |n| ~firstOct.wrapAt(n) };
// Extends chord notes over midi range
var i = 0, temp = Array.new(120);
while { i <= 127 } {

}
)

