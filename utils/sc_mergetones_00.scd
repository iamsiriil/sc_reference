(
~a = [1, 1, 1, 2, 2, 2];
~b = [1, 1, 1, 1, 1, 1];

"a: % | b: %".format(~a, ~b).postln;
~c = Array.new(6);
~d = Array.new(6);

~a.do { |n, i|

	if (i > 0) {

		if (n == ~a[i - 1]) {
			~b[i - 1] = ~b[i - 1] + ~b.removeAt(i);
			~a.removeAt(i);
		}
	}
};

"a: % | b: %".format(~a, ~b).postln;
)

(
var a = [1, 1, 1, 2, 2, 2, 3, 3];
var b = [1, 1, 1, 1, 1, 1, 2, 2];

var tempa = Array.new(a.size);
var tempb = Array.new(a.size);

"a: % | b: %".format(a, b).postln;

a.do { |n, i|

	if ( i == 0) {
		tempa.add(n);
		tempb.add(b[i]);
	};
	if ((i > 0) && (n != tempa.last)) {
		tempa.add(n);
		tempb.add(b[i]);
	};
	if ((i > 0) && (i < (a.size - 1)) && (n == tempa.last)) {
		tempb[tempb.size - 1] = tempb[tempb.size - 1] + b[i];
	};
	i.postln;
};

"tempa: % | tempb: %".format(tempa, tempb).postln;
)

~a = [1, 2, 3];
~a