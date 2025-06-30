(
~prog = [1, 2, 2, 3, 4, 5];
~dur = [1, 1, 1, 1, 1, 1];
~nprog = Array.new(~prog.size);
~ndur = Array.new(~prog.size);

~func = { |prog, dur, nprog, ndur, new, i|
	var result;

	block { |return|

		if (i == (prog.size)) {
			result = [nprog, ndur];
			return.value(result);
		};

		if (i == 0) {
			new = prog[i].postln;
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~func.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		};

		if ((i > 0) && (new != prog[i])) {
			new = prog[i].postln;
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~func.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		} {
			ndur[ndur.size - 1] = ndur[ndur.size - 1] + dur[i];
		};

		result = ~func.(prog, dur, nprog, ndur, new, i + 1);
		return.value(result);

	};
	result;
};
~func.(~prog, ~dur, ~nprog, ~ndur, 0, 0);
)