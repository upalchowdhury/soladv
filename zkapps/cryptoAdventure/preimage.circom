pragma circom 2.0.0;
include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/mimc.circom";

template HashCheckWithBound() {
    signal input preimage;
    signal input key; // added key as an input
    signal input upperBound;
    signal output isSatisfied;

    component hasher = MiMC7(10);
    hasher.x_in <== preimage;
    hasher.k <== key;

    component comparator = LessThan(2);
    comparator.in[0] <== hasher.out;
    comparator.in[1] <== upperBound;

    isSatisfied <== comparator.out;
}

component main = HashCheckWithBound();
