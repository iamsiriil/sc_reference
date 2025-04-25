s.boot;

(
~intervals = [1, 2, 3, 4, 5];
~intervCount = [29, 150, 41, 4, 5];
~intervWeight = ~intervCount.normalizeSum;
)


~intervals[~intervWeight.windex] * [-1, 1].choose;

~intervals;