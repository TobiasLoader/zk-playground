pragma circom 2.0.0;

template IsSquare(n) {
    signal input x;
    signal output out;
    signal temp[n];

    var match = 0;

    for (var i = 1; i <= n; i++) {
      temp[i-1] <== i * i;
      if (x == temp[i-1]) {
        match = 1;
      }
    }
    
    out <-- match;
}

component main = IsSquare(10);