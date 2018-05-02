library CounterLib {
    struct Counter { uint i; }

    function incremented(Counter storage self) returns (uint) {
        return ++self.i;
    }
}

contract CounterContract {
    using CounterLib for CounterLib.Counter;

    CounterLib.Counter counter;

    function increment() returns (uint) {
        return counter.incremented();
    }
}