pragma circom 2.0.0;

template Voting(candN, voteN) {
  signal input votes[voteN][2];
  signal input candidates[candN];
  signal output out[candN+voteN];

  component comparisons[voteN][candN];
  for (var v = 0; v < voteN; v++) {
    for (var c = 0; c < candN; c++) {
      comparisons[v][c] = IsEqual();
      comparisons[v][c].in[0] <== votes[v][1];
      comparisons[v][c].in[1] <== candidates[c];
    }
  }

  var sumForCandidate[candN];
  for (var c = 0; c < candN; c++) {
    sumForCandidate[c] = 0;
    for (var v = 0; v < voteN; v++) {
      sumForCandidate[c] += comparisons[v][c].out;
    }
    out[c] <== sumForCandidate[c];
  }
  for (var v = 0; v < voteN; v++) {
    out[v+candN] <== votes[v][0];
  }
}

// Define the IsEqual template
template IsEqual() {
  signal input in[2];
  signal output out;
  
  component iszero = IsZero();
  iszero.in <== in[0] - in[1];

  out <== iszero.out;
}

template IsZero() {
  signal input in;
  signal output out;
  signal inv;
  inv <-- in!=0 ? 1/in : 0;
  out <== -in*inv +1;
  in*out === 0;
}

component main {public [candidates]} = Voting(2,3);