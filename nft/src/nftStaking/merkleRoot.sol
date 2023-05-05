pragma solidity ^0.8.0;

contract MerkleRootExample {
    // function computeMerkleRoot(bytes32[] memory hashes) public pure returns (bytes32) {
    //     uint256 len = hashes.length;
    //     require(len > 0, "At least one hash is required");

    //     while (len > 1) {
    //         if (len % 2 != 0) {
    //             hashes.push(hashes[len - 1]);
    //             len++;
    //         }

    //         for (uint256 i = 0; i < len; i += 2) {
    //             hashes[i / 2] = sha256(abi.encodePacked(hashes[i], hashes[i + 1]));
    //         }

    //         len /= 2;
    //     }

    //     return hashes[0];
    // }
bytes32 merkleRoot;
bytes32 hash1 = 0x7a6be8e1b5d59c07e6c707090a85910bb3d4c41d7faa36f2e1dd61e1c30a8de2;
bytes32 hash2 = 0xfce9e1c4de5a5929290a3c5162f7d93faa0479ec9b24570d763711b7298ecf14;
bytes32 hash3 = 0x4b0db8b02ed7034d68810b8d82c616524beaf3722d7cf1627342253e5a630a20;

// address _to;
// uint _tokenId;
bytes32 leaf = keccak256(abi.encodePacked(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, uint256(6)));
    //uint[] public arr2 = [1, 2, 3];

// bytes32[] internal hashes = new bytes32[](3);
// bytes32 hashes[0] = hash1;
// bytes32 hashes[1] = hash2;
// bytes32 hashes[2] = hash3;
bytes32[] public hashes = [hash1,hash2,hash3];



//   function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal view returns (bool) {
//         return processProof(proof, leaf) == merkleRoot;
//     }


 function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }


function getMr() external view returns (bytes32) {
    return processProof(hashes,leaf);
}



function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }





}}