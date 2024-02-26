template IsFibonacci(n) {
    signal input a;
    signal output out;
    
    var fib0 = 0;
    var fib1 = 1;
    var fib2 = 1;

    for (var i = 0; i < n; i++) {
      fib2 = fib0 + fib1;
      fib0 = fib1;
      fib1 = fib2;
    }

    out <-- a == fib0;
}

component main = IsFibonacci(10);