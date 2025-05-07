/*
DATA STRUCTURES

-> chordProg     Array
-> firstChord    Array
-> currentChord  Array
-> nextChord     Array

-> chordList     Dictionary / OrderedIdentitySet
-> validNotes    Set

************************************************************
FLAGS

hasCommonToneSpn        true/false
hasCommonToneAlt        true/false
hasCommonToneTen        true/false
hasCommonToneBas       .true/false

enforceCommonTones      true/false

enforceRootPosition     true/false
enforceFirstInvertion   true/false

enforceDuplicatRoot     true/false
enforceDuplicat3Degree  true/false

enforceParallelFifths   true/false
enforceParallelOctaves  true/False

*/

// Dictionary
(
~d = Dictionary[
	\a->[1, 2, 3],
	\b->[4, 5, 6]
];
)
~d.class;

// Sets
~set = Set[];
~iSet = IdentitySet[];
~oISet = OrderedIdentitySet[];
