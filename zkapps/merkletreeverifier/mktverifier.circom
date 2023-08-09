pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/poseidon.circom";

template PublicKeyGenerator() {
    signal input privateKey;
    signal output publicKey;

    component hash = Poseidon(1);
    hash.inputs[0] <== privateKey;
    
    publicKey <== hash.out;
}

template MerkleTreeVerifier() {
    signal input privateKey;

    signal input siblings[2]; // Since we're interested in 4 keys, we need a binary tree of depth 2.

    signal input root;

    component keyGenerator = PublicKeyGenerator();
    keyGenerator.privateKey <== privateKey;

    component hash1 = Poseidon(2);
    component hash2 = Poseidon(2);

    // Assuming leftmost leaf, change according to provided sibling
    hash1.inputs[0] <== keyGenerator.publicKey;
    hash1.inputs[1] <== siblings[0];

    hash2.inputs[0] <== hash1.out;
    hash2.inputs[1] <== siblings[1];

    hash2.out === root; // If the final hash equals the root, the proof is valid.

}

component main = MerkleTreeVerifier();