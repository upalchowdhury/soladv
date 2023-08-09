pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";


template SujikoVerifier() {
    signal input grid[9];
    signal input sums[4];
    signal output out;


    // Compute the four corner sums
    sums[0] === grid[0] + grid[1] + grid[3] + grid[4];
    sums[1] === grid[1] + grid[2] + grid[4] + grid[5];
    sums[2] === grid[3] + grid[4] + grid[6] + grid[7];
    sums[3] === grid[4] + grid[5] + grid[7] + grid[8];





// uniqueness check
    var n = 9;
    component isEq[n * (n - 1) / 2];

    var index = 0;
    
    for (var i = 0; i < n; i++) {
        for (var j = i+1; j < n; j++) {
            isEq[index] = IsEqual();
            isEq[index].in[0] <== grid[i];
            isEq[index].in[1] <== grid[j];
            isEq[index].out === 0;
            index++;
        }
    }

    out <== 1;
}



    // // Check if all numbers from 1 to 9 are used
    // component checkValidNumbers[36] = UniqueCheck(9);
    // for (var i = 0; i < 9; i++) {
    //     checkValidNumbers.in[i] <== grid[i];
    // }
    // validNumbers <== checkValidNumbers.valid;






// template Unique9Numbers() {

//     // Check that there are no duplicates
//     for (var i=0; i<9; i++) {
//         for (var j=i+1; j<9; j++) {
//             assert(grid[i] !== grid[j]);
//         }
//     }
//     // signal input numbers[9];
//     // signal output valid;

//     // signal  checks[81];
//     // signal  sum[9];  
//     // signal  acc[9][9];

//     // for (var i = 0; i < 9; i++) {
//     //     for (var j = 0; j < 9; j++) {
//     //         checks[i * 9 + j] <== numbers[i] * (numbers[i] - (j + 1));
//     //     }
//     // }

//     // // Each number from 1 to 9 must appear exactly once
//     // for (var j = 0; j < 9; j++) {
//     //     acc[0][j] <== 1 - checks[j] * checks[j];  // initialize for i=0 using quadratic constraint
//     //     for (var i = 1; i < 9; i++) {
//     //         acc[i][j] <== acc[i-1][j] + (1 - checks[i * 9 + j] * checks[i * 9 + j]);
//     //     }
//     //     sum[j] <== acc[8][j];  // the last accumulated value
//     //     assert(sum[j] == 1);
//     // }

//     // valid <== 1;
// }
component main {public [sums]} = SujikoVerifier();

