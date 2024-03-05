pragma circom 2.0.0;

template AgeVerif() {
    signal input age;
    signal input limit;
    signal output out;

    signal above;
    above <-- (age >= limit) ? 1 : 0;
    
    out <== above;
}

component main {public [limit]} = AgeVerif();