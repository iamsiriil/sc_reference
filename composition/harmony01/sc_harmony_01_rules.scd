s.boot;
s.quit;

/**************************************************************************************
- HARMONY 01 / Rule Enforcement and Tests
**************************************************************************************/

(
// Flags
~hasCommonToneSpn       = true;
~hasCommonToneAlt       = true;
~hasCommonToneTen       = true;
~hasCommonToneBas       = true;

~enforceCommonTones     = true;

~enforceRootPosition    = true;
~enforceFirstInvertion  = true;

~enforceDuplicatRoot    = true;
~enforceDuplicat3Degree = true;

~enforceParallelFifths  = true;
~enforceParallelOctaves = true;

~enforceVoiceSpacing    = true;

~count = 0;

// Drop rules if valid chord cannot be found
~toggleRules = {
	switch (~count)
	{ 0 } { ~enforceRootPosition == false }
	{ 1 } { ~enforceDuplicateRoot == false }
	{ 2 } {
		~enforceParallelFifths == false;
		~enforceParallelOctave == false;
	};
	~count = ~count + 1;
};

// Reset original rules
~resetRules = {
	if (~enforceRootPosition == false)   { ~enforceRootPosition == true };
	if (~enforceDuplicatRoot == false)   { ~enforceDuplicatRoot == true };
	if (~enforceParallelFifths == false) { ~enforceParallelFifths == true };
	if (~enforceParallelOctaves == false) { ~enforceParallelOctaves == true };
};
)
