s.boot;

/**************************************************************************************************************
- QUEUE 00
**************************************************************************************************************/

(
~createQueue = { |maxSize|
	var queue = (
		\list: List.new(maxSize),
		\maxSize: maxSize
	);
	queue;
};

~isFull = { |queue| if (queue[\list].size == queue[\MaxSize]) { true } { false } };

~enqueue = { |queue, data|
	if (~isFull.(queue) == true) {
		"ERROR: Queue overflow".postln;
	} {
		queue[\list].add(data);
	}
};

~dequeue = { |queue|
	if (queue[\list].isEmpty == true) {
		"ERROR: Queue underflow".postln;
		nil;
	} {
		queue[\list].removeAt(0);
	}
};

~clearQueue = { |array| array.clear };
)
