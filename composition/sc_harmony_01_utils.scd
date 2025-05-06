s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Utility Functions
**************************************************************************************/

(
// ~getMIDINoteNames -> Takes a sequence of midi numbers and returns the corresponting
// list of note names. C
~getMIDINoteNames = { |notes|
	notes.collect { |note| ~midiRange[\name][note] };
};

// ~getMIDINoteNamesOct -> Takes a sequence of midi numbers and returns the corresponding
// list of note names with respective octaves. C4
~getMIDINoteNamesOct = { |notes|
	notes.collect { |note| ~midiRange[\octave][note] };
};
/*
-> Other utility function

-> isRoot, isThird, isFifth:

type - type of interval (Major, Minor, Perfect, etc.)
chordName - Name of chord being expressed (Gm, CM, Dd, etc.)
context - Array of midi notes (range, chord, scale, etc.)
note - note of which the degree is to be determined (M3, P5, Rt, d5, etc.)

return -> true / false
*/

~isRoot = { |chordName, context, note| };

~isThird = { |type, chordName, context, note|
	switch (type)
	//{ "d" } {  }
	{ 'm' } {  }
	{ 'M' } {  }
	//{ "A" } {  }
};

~isFifth = { |type, chordName, context, note|
	switch (type)
	{ 'd' } {  }
	{ 'P' } {  }
	{ 'A' } {  }
};

/*
-> resolveInharmonics

chordName - Name of chord being expressed
context - Array of midi notes

return -> corresponding array with note names with inharmonics resolved
E.g.: [B, D#, G] -> [B, D#, F##] : B Augmented triad
*/

~resolveInharmonics = { |chordName, context| };
)

~a = ~getMIDINoteNamesOct.(~chords[\Cd][0]);
~s = ~getMIDINoteNames.(~chords[\Cd][0]);
