s.boot;
s.quit;

s.plotTree;

/*******************************************************************

'soundbank' contains categorized subfolders (e.g., drums, keyboard),
allowing structured and recursive loading of all sound files.

Sound file names are normalized (e.g., kd_00, sd_01), making it easy
to generate concise and descriptive symbols for buffer access.

*******************************************************************/

// Resolves the path relative to the location of this .scd file
~sb = PathName.new("./../soundbank/".resolveRelative);

(
~sb.entries.do { |folder|
	folder.postln;
};
)

(
~b = ();
~sb.entries.do { |subfolder|
	subfolder.entries.do { |ssubfolder|
		ssubfolder.entries.do { |file|
			file.do { |fname|
				~b[file.fileNameWithoutDoubleExtension.asSymbol] = Buffer.read(s, fname.fullPath);
			};
		};
	};
};
)

~bp = { PlayBuf.ar(~b[\kd_00].numChannels, ~b[\kd_00].bufnum, loop: 1, doneAction: 2) };

~bp.play;


