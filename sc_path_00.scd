s.boot;
s.quit;

s.plotTree;

/*******************************************************************/

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

~b[\kd_00].play;

