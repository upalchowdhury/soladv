template UniqueCheck(n) {
    signal input in[n];
    component isEq[n * (n - 1) / 2];

    var index = 0;
    
    for (var i = 0; i < n; i++) {
        for (var j = i+1; j < n; j++) {
            isEq[index] = IsEqual();
            isEq[index].in[0] <== in[i];
            isEq[index].in[1] <== in[j];
            isEq[index].out === 0;
            index++;
        }
    }
}