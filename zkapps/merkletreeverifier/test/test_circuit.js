const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const poseidon = require("circomlibjs").poseidon;
console.log(poseidon);
const {merkelize, getMerkleProof} = require("./mktFuncts.js");
//const F = require("circomlibjs").babyjub.F;
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
const crypto = require('crypto');

exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617",
);

const F = new F1Field(exports.p);


function hashString(input) {
    const hash = crypto.createHash('sha256');
    hash.update(input);
    return hash.digest('hex');
}

// Example usage:
const data = "Hello, world!";
console.log(hashString(data));  // Outputs a SHA-256 hash of the string

describe("Check Merkle tree Circuit", function () {
    let circuit;

    this.timeout(10000000);

    before( async() => {
        circuit = await wasm_tester(path.join(__dirname, "../", "mktverifier.circom"));
    });

    it("Should check inclussion in MT", async () => {
        const m = merkelize(F, poseidon, [11,22,33,44], 2);
        console.log(m);
        const root = m[0];
        const mp = getMerkleProof(m, 1, 2);
        console.log(mp);

        const input={
            key: F.e(1), // this is the node location of the public key of the secret key
            value: F.e(33),// this is the secret key
            root: root,   
            siblings: mp
        };

        await circuit.calculateWitness(input, true);
    });

});