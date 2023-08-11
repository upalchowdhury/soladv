const chai = require("chai");
const assert = chai.assert;

const poseidon = require("circomlibjs").poseidon;
const {merkelize, getMerkleProof, isMerkleProofValid } = require("mktFuncts.js");

const F = require("circomlibjs").babyjub.F;

describe("Merkle tree test", function () {
    it("It should create a 3 level merkle tree, generate a mp and validate it", async () => {

        const m = merkelize(F, poseidon, [11,22,33,44,55,66,77,88], 3);
        const root = m[0];
        const mp = getMerkleProof(m, 2, 3);

        assert( isMerkleProofValid(F, hash, 2, 33, root, mp)  );
    });
});



});