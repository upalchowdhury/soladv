pragma solidity 0.8.18;

contract SudokuGame {
    uint8[9][9] private board;
    
    event NumberPlaced(uint8 row, uint8 col, uint8 number);
    
    function placeNumber(uint8 row, uint8 col, uint8 number) public {
        require(row < 9 && col < 9, "Invalid row or column");
        require(number >= 1 && number <= 9, "Invalid number");
        require(board[row][col] == 0, "Cell already occupied");
        require(validatePlacement(row, col, number), "Invalid placement");
        
        board[row][col] = number;
        
        emit NumberPlaced(row, col, number);
    }
    
    function getNumber(uint8 row, uint8 col) public view returns (uint8) {
        require(row < 9 && col < 9, "Invalid row or column");
        return board[row][col];
    }
    
    function validatePlacement(uint8 row, uint8 col, uint8 number) private view returns (bool) {
        // Check row and column constraints
        for (uint8 i = 0; i < 9; i++) {
            if (board[row][i] == number || board[i][col] == number) {
                return false;
            }
        }
        
        // Check 3x3 box constraints
        uint8 boxRow = row - row % 3;
        uint8 boxCol = col - col % 3;
        
        for (uint8 i = 0; i < 3; i++) {
            for (uint8 j = 0; j < 3; j++) {
                if (board[boxRow + i][boxCol + j] == number) {
                    return false;
                }
            }
        }
        
        return true;
    }
}
