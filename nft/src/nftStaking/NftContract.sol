// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
//import "@openzeppelin/contracts/token/ERC721/extensions/IERC2917.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract DiscountedNFT is ERC721, IERC2981 {
    using SafeMath for uint256;

    bytes32 public merkleRoot;

    // Map each address to a 256 bit slot
    // This is a packed array of booleans.
    mapping(uint256 => uint256) private claimedBitMap;
    mapping (address => uint256) private claimedMap;
    uint256 public discountPercentage;

    uint256 public constant ROYALTY_PERCENTAGE = 250;

    // get token owners
    mapping(uint256 => address) private _owners;
    mapping (uint256 => address) private _tokenOwners;

    // Mapping from token ID to approved address
    mapping(uint => address) internal _approvals;

    // Mapping from owner to operator approvals
    //mapping(address => mapping(address => bool)) internal isApprovedForAll;

   // mapping(address => mapping(address => bool)) public virtual override isApprovedForAll;

    // Event that is emitted when a new NFT is minted
    event Minted(address indexed recipient, uint256 indexed tokenId);

    constructor(string memory _name, string memory _symbol, bytes32 _merkleRoot, uint256 _discountPercentage) ERC721(_name, _symbol) {
        merkleRoot = _merkleRoot;
        discountPercentage = _discountPercentage;
    }

    bytes32 hash1 = 0x7a6be8e1b5d59c07e6c707090a85910bb3d4c41d7faa36f2e1dd61e1c30a8de2;
    bytes32 hash2 = 0xfce9e1c4de5a5929290a3c5162f7d93faa0479ec9b24570d763711b7298ecf14;
    bytes32 hash3 = 0x4b0db8b02ed7034d68810b8d82c616524beaf3722d7cf1627342253e5a630a20;
    bytes32[] public hashes = [hash1,hash2,hash3];


    function _merkleProof() internal view returns (bytes32[] memory){
       

        // myArray[0] = "0x1234567890abcdef";
        // myArray[1] = "0xfedcba9876543210";
        // myArray[2] = "0xdeadbeefcafebab";
        //bytes32[] public hashes = [hash1,hash2,hash3];

        return hashes;

    
}

/**
 *                  Adapted from Uniswap v2 and used as refference
 * 
 * 
 * 
 * 
 * 
 * 
 */
// function isClaimed(uint256 index) public view override returns (bool) {
//         uint256 claimedWordIndex = index / 256;
//         uint256 claimedBitIndex = index % 256;
//         uint256 claimedWord = claimedBitMap[claimedWordIndex];
//         uint256 mask = (1 << claimedBitIndex);
//         return claimedWord & mask == mask;
//     }

// function _setClaimed(uint256 index) private {
//         uint256 claimedWordIndex = index / 256;
//         uint256 claimedBitIndex = index % 256;
//         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
//     }

// function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof)
//         public
//         virtual
//         override
//     {
//         if (isClaimed(index)) revert AlreadyClaimed();

//         // Verify the merkle proof.
//         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
//         if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();

//         // Mark it claimed and send the token.
//         _setClaimed(index);
//         IERC20(token).safeTransfer(account, amount);

//         emit Claimed(index, account, amount);
//     }


//super.myFunction(myArray);

// , bytes32[] calldata _merkleProof

    function mint(address _to, uint256 _tokenId) external {
        require(_to != address(0), "Cannot mint to zero address");
        require(!_exists(_tokenId), "Token ID already exists");

        // Verify that the address has not already claimed the token
        //uint256 claimedWordIndex = _tokenId / 256;
        uint256 claimedBitIndex = _tokenId % 256;
        uint256 claimedWord = claimedMap[_to];
        uint256 claimedBit = claimedWord & (1 << claimedBitIndex);
        require(claimedBit == 0, "Token already claimed");

        // Verify the merkle proof
        bytes32 leaf = keccak256(abi.encodePacked(_to, _tokenId));
        //bytes32[] _merkleProof = _merkleProof();
        require(MerkleProof.verify(_merkleProof(), merkleRoot, leaf), "Invalid proof");

        // Mark the token as claimed by the address
        claimedMap[_to] = claimedWord | (1 << claimedBitIndex);
        claimedBitMap |= (1 << (_tokenId % 256));

        // Mint the token to the address and update _owners mapping
        _mint(_to, _tokenId);
        _tokenOwners[_tokenId] = _to;

        emit Minted(_to, _tokenId);
    }

    function getClaimStatus(address _address, uint256 _tokenId) external view returns (bool) {
        //uint256 claimedWordIndex = _tokenId / 256;
        uint256 claimedBitIndex = _tokenId % 256;
        uint256 claimedWord = claimedMap[_address];
        uint256 claimedBit = claimedWord & (1 << claimedBitIndex);
        return claimedBit != 0;
    }

    // function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal {
    //     require(!isClaimed(tokenId), "Token already claimed");
    //     super._beforeTokenTransfer(from, to, tokenId);
    // }


function isClaimed(uint256 tokenId) public view returns (bool) {
    //uint256 claimedWordIndex = tokenId / 256;
    uint256 claimedBitIndex = tokenId % 256;
    uint256 claimedWord = claimedBitMap & (1 << claimedBitIndex);
    return claimedWord != 0;
}
function royaltyRate() internal pure returns (uint256){
    return ROYALTY_PERCENTAGE;
}
function royaltyInfo(uint256 tokenId, uint256 value) external view override returns (address receiver, uint256 royaltyAmount) {
    return (getOwnerOfToken(tokenId), value.mul(royaltyRate()).div(10000));
}



    // Function to get the owner of a specific token
function getOwnerOfToken(uint256 tokenId) public view returns (address) {
        return _tokenOwners[tokenId];
    }

    // Function to list all token owners
function listAllTokenOwners() public view returns (address[] memory) {
        uint256 totalTokens = getTotalTokens();
        address[] memory owners = new address[](totalTokens);

        for (uint256 i = 0; i < totalTokens; i++) {
            owners[i] = _tokenOwners[i];
        }

        return owners;
    }

    




    // Helper function to get the total number of tokens
    function getTotalTokens() public pure returns (uint256) {
        uint totalSupply = 10000;
        return totalSupply;
    }
}



