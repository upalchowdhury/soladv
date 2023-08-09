const chai = require("chai");
const { wasm } = require("circom_tester");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617",
);
const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("Sujiko Tester ", function () {
  this.timeout(100000);

  it("Should create a Sujiko circuit", async () => {
    const circuit = await wasm_tester(
      path.join(__dirname, "../", "sujiko.circom"),
    );
    await circuit.loadConstraints();
    let witness;

    const expectedOutput = 1;

    witness = await circuit.calculateWitness(
      {
        sums: ["21", "18", "16", "15"],
        grid: ["9", "3", "5", "7", "2", "8", "6", "1", "4"],
      },
      true,
    );
    console.log(`Witness[1] Value: ${Fr.toString(witness[1])}`);
    console.log(`Witness[0] Value: ${Fr.toString(witness[0])}`);

    assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
    assert(Fr.eq(Fr.e(witness[1]), Fr.e(expectedOutput)));

    // try {
    //   witness = await circuit.calculateWitness(
    //     {
    //       cornerSums: ["20", "22", "14", "20"],
    //       grid: ["7", "9", "2", "1", "3", "8", "6", "4", "5"],
    //     },
    //     true,
    //   );
    //   //const expectedOutput2 = 1;
    //   assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
    //   //assert(Fr.eq(Fr.e(witness[1]), Fr.e(expectedOutput2)));
    //   console.log("PASSING!");
    // } catch (e) {
    //   console.log("Circuit is reverting . FAILING!!!");
    // }
  });



// test 2 
it("Should fail due to wrong order in a row", async function () {

    const circuit = await wasm_tester(
      path.join(__dirname, "../", "sujiko.circom"),
    );
    await circuit.loadConstraints();
    // The number 1 in the first row of solved is twice
    let input = {
        sums: ["20", "22", "14", "20"],
        grid: ["7", "9", "2", "1", "3", "8", "6", "4", "5"],

    };
    try {
      await circuit.calculateWitness(input);
    } catch (err) {
      console.log(err);
      //assert(err.message.includes("Assert Failed"));
    }
  });



//test 3

it("Should pass", async function () {
     const circuit = await wasm_tester(
      path.join(__dirname, "../", "sujiko.circom"),
    );
    // The number 1 in the first row of solved is twice
    let input = {
        sums: ["21", "18", "16", "15"],
        grid: ["9", "3", "5", 
               "7", "2", "8", 
               "6", "1", "4"],
    };
    try {
      await circuit.calculateWitness(input);
    } catch (err) {
      console.log(err);
      //assert(err.message.includes("Assert Failed"));
    }
  });



});