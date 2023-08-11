pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/switcher.circom";
include "./node_modules/circomlib/circuits/poseidon.circom";
include "./node_modules/circomlib/circuits/bitify.circom";


// template PublicKeyGenerator() {
//     signal input privateKey;
//     signal output publicKey;

//     component hash = Poseidon(1);
//     hash.inputs[0] <== privateKey;
    
//     publicKey <== hash.out;
// }

template MerkleTreeVerifier() {
    signal input pKey;
    signal input sibling; // Since we're interested in 4 keys, we need a binary tree of depth 2.
    signal input low;
    signal input value;

    signal output root;

    component hashV = Poseidon(1);

    hashV.inputs[0] <== value;

    n2b.in <== key;

    component sw = Switcher();
    component n2b = Num2Bits(nLevels);


    component hash1 = Poseidon(2);
    component hash2 = Poseidon(2);

    // Assuming leftmost leaf, change according to provided sibling
    hash1.inputs[0] <== pKey;
    hash1.inputs[1] <== low;

    hash2.inputs[0] <== hash1.out;
    hash2.inputs[1] <== sibling;

    hash2.out ==> root; // If the final hash equals the root, the proof is valid.

}

component main  = MerkleTreeVerifier();



// template Mkt2VerifierLevel() {
//     signal input sibling;
//     signal input low;
//     signal input selector;
//     signal output root;

//     component sw = Switcher();
//     component hash = Poseidon(2);

//     sw.sel <== selector;
//     sw.L <== low;
//     sw.R <== sibling;

//     log(44444444444);
//     log(sw.outL);
//     log(sw.outR);

//     hash.inputs[0] <== sw.outL;
//     hash.inputs[1] <== sw.outR;

//     root <== hash.out;
// }

// template Mkt2Verifier(nLevels) {

//     signal input key;
//     signal input value;
//     signal input root;
//     signal input siblings[nLevels];

//     component n2b = Num2Bits(nLevels);
//     component levels[nLevels];

//     component hashV = Poseidon(1);

//     hashV.inputs[0] <== value;

//     n2b.in <== key;

//     for (var i=nLevels-1; i>=0; i--) {
//         levels[i] = Mkt2VerifierLevel();
//         levels[i].sibling <== siblings[i];
//         levels[i].selector <== n2b.out[i];
//         if (i==nLevels-1) {
//             levels[i].low <== hashV.out;
//         } else {
//             levels[i].low <== levels[i+1].root;
//         }
//     }

//     root === levels[0].root;
// }

// component main {public [root]}= Mkt2Verifier(3);
// pragma circom 2.0.0;

// include "./node_modules/circomlib/circuits/poseidon.circom";

// template PublicKeyGenerator() {
//     signal input privateKey;
//     signal output publicKey;

//     component hash = Poseidon(1);
//     hash.inputs[0] <== privateKey;
    
//     publicKey <== hash.out;
// }

// template MerkleTreeVerifier() {
//     signal input pKey;

//     signal input siblings[2]; // Since we're interested in 4 keys, we need a binary tree of depth 2.

//     signal input root;

//     component keyGenerator = PublicKeyGenerator();
//     keyGenerator.privateKey <== pKey;

//     component hash1 = Poseidon(2);
//     component hash2 = Poseidon(2);

//     // Assuming leftmost leaf, change according to provided sibling
//     hash1.inputs[0] <== keyGenerator.publicKey;
//     hash1.inputs[1] <== siblings[0];

//     hash2.inputs[0] <== hash1.out;
//     hash2.inputs[1] <== siblings[1];

//     hash2.out === root; // If the final hash equals the root, the proof is valid.

// }

// component main = MerkleTreeVerifier();