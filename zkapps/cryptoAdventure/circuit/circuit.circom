include "hashes/sha256/sha256.circom";
include "comparison.circom";

template HashCheckWithBound() {
    signal private input preimage[256];
    signal input hash[256];
    signal input bound[256];

    // Compute the hash of the preimage
    component hasher = Sha256(preimage);

    // Check that the hash of the preimage matches the given hash
    for (var i = 0; i < 256; i++) {
        constraint hasher.out[i] === hash[i];
    }

    // Check that the preimage is larger than the bound
    component comparator = GreaterThan(preimage, bound);
    constraint comparator.out === 1;
}

component main = HashCheckWithBound();
