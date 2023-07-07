
from __future__ import annotations

import dataclasses
from typing import List, Dict, Optional, overload, Union, Callable, Tuple
from typing_extensions import Literal

from woke.development.core import Contract, Library, Address, Account, Chain, RequestType
from woke.development.primitive_types import *
from woke.development.transactions import TransactionAbc, TransactionRevertedError

from enum import IntEnum

from pytypes.openzeppelin.contracts.proxy.ERC1967.ERC1967Upgrade import ERC1967Upgrade
from pytypes.openzeppelin.contracts.proxy.Proxy import Proxy



class ERC1967Proxy(ERC1967Upgrade, Proxy):
    """
    [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#15)
    """
    _abi = {'constructor': {'inputs': [{'internalType': 'address', 'name': '_logic', 'type': 'address'}, {'internalType': 'bytes', 'name': '_data', 'type': 'bytes'}], 'stateMutability': 'payable', 'type': 'constructor'}, 'fallback': {'stateMutability': 'payable', 'type': 'fallback'}, 'receive': {'stateMutability': 'payable', 'type': 'receive'}}
    _creation_code = "608060405260405161083838038061083883398181016040528101906100259190610501565b61003682825f61003d60201b60201c565b505061071d565b61004c8361007460201b60201c565b5f825111806100585750805b1561006f5761006d83836100c960201b60201c565b505b505050565b610083816100fc60201b60201c565b8073ffffffffffffffffffffffffffffffffffffffff167fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b60405160405180910390a250565b60606100f48383604051806060016040528060278152602001610811602791396101be60201b60201c565b905092915050565b61010b8161024660201b60201c565b61014a576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610141906105db565b60405180910390fd5b8061017c7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc5f1b61026860201b60201c565b5f015f6101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b60605f808573ffffffffffffffffffffffffffffffffffffffff16856040516101e7919061063d565b5f60405180830381855af49150503d805f811461021f576040519150601f19603f3d011682016040523d82523d5f602084013e610224565b606091505b509150915061023b8683838761027160201b60201c565b925050509392505050565b5f808273ffffffffffffffffffffffffffffffffffffffff163b119050919050565b5f819050919050565b606083156102d8575f8351036102d0576102908561024660201b60201c565b6102cf576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016102c69061069d565b60405180910390fd5b5b8290506102e9565b6102e883836102f160201b60201c565b5b949350505050565b5f825111156103035781518083602001fd5b806040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161033791906106fd565b60405180910390fd5b5f604051905090565b5f80fd5b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f61037a82610351565b9050919050565b61038a81610370565b8114610394575f80fd5b50565b5f815190506103a581610381565b92915050565b5f80fd5b5f80fd5b5f601f19601f8301169050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b6103f9826103b3565b810181811067ffffffffffffffff82111715610418576104176103c3565b5b80604052505050565b5f61042a610340565b905061043682826103f0565b919050565b5f67ffffffffffffffff821115610455576104546103c3565b5b61045e826103b3565b9050602081019050919050565b5f5b8381101561048857808201518184015260208101905061046d565b5f8484015250505050565b5f6104a56104a08461043b565b610421565b9050828152602081018484840111156104c1576104c06103af565b5b6104cc84828561046b565b509392505050565b5f82601f8301126104e8576104e76103ab565b5b81516104f8848260208601610493565b91505092915050565b5f806040838503121561051757610516610349565b5b5f61052485828601610397565b925050602083015167ffffffffffffffff8111156105455761054461034d565b5b610551858286016104d4565b9150509250929050565b5f82825260208201905092915050565b7f455243313936373a206e657720696d706c656d656e746174696f6e206973206e5f8201527f6f74206120636f6e747261637400000000000000000000000000000000000000602082015250565b5f6105c5602d8361055b565b91506105d08261056b565b604082019050919050565b5f6020820190508181035f8301526105f2816105b9565b9050919050565b5f81519050919050565b5f81905092915050565b5f610617826105f9565b6106218185610603565b935061063181856020860161046b565b80840191505092915050565b5f610648828461060d565b915081905092915050565b7f416464726573733a2063616c6c20746f206e6f6e2d636f6e74726163740000005f82015250565b5f610687601d8361055b565b915061069282610653565b602082019050919050565b5f6020820190508181035f8301526106b48161067b565b9050919050565b5f81519050919050565b5f6106cf826106bb565b6106d9818561055b565b93506106e981856020860161046b565b6106f2816103b3565b840191505092915050565b5f6020820190508181035f83015261071581846106c5565b905092915050565b60e8806107295f395ff3fe608060405236601057600e6018565b005b60166018565b005b601e602c565b602a6026602e565b603a565b565b565b5f60356058565b905090565b365f80375f80365f845af43d5f803e805f81146054573d5ff35b3d5ffd5b5f60827f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc5f1b60a9565b5f015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b5f81905091905056fea26469706673582212203c2c28071093feaa0c12fc9e0ee101b9f2a424571b797bbf4ac4d7396277c42664736f6c63430008140033416464726573733a206c6f772d6c6576656c2064656c65676174652063616c6c206661696c6564"

    @overload
    @classmethod
    def deploy(cls, _logic: Union[Account, Address], _data: Union[bytearray, bytes], *, from_: Optional[Union[Account, Address, str]] = None, value: Union[int, str] = 0, gas_limit: Optional[Union[int, Literal["max"], Literal["auto"]]] = None, return_tx: Literal[False] = False, request_type: Literal["call"], chain: Optional[Chain] = None, gas_price: Optional[Union[int, str]] = None, max_fee_per_gas: Optional[Union[int, str]] = None, max_priority_fee_per_gas: Optional[Union[int, str]] = None, access_list: Optional[Union[Dict[Union[Account, Address, str], List[int]], Literal["auto"]]] = None, type: Optional[int] = None, block: Optional[Union[int, Literal["latest"], Literal["pending"], Literal["earliest"], Literal["safe"], Literal["finalized"]]] = None, confirmations: Optional[int] = None) -> bytearray:
        """
        [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#22)

        Args:
            _logic: address
            _data: bytes
        """
        ...

    @overload
    @classmethod
    def deploy(cls, _logic: Union[Account, Address], _data: Union[bytearray, bytes], *, from_: Optional[Union[Account, Address, str]] = None, value: Union[int, str] = 0, gas_limit: Optional[Union[int, Literal["max"], Literal["auto"]]] = None, return_tx: Literal[False] = False, request_type: Literal["tx"] = "tx", chain: Optional[Chain] = None, gas_price: Optional[Union[int, str]] = None, max_fee_per_gas: Optional[Union[int, str]] = None, max_priority_fee_per_gas: Optional[Union[int, str]] = None, access_list: Optional[Union[Dict[Union[Account, Address, str], List[int]], Literal["auto"]]] = None, type: Optional[int] = None, block: Optional[Union[int, Literal["latest"], Literal["pending"], Literal["earliest"], Literal["safe"], Literal["finalized"]]] = None, confirmations: Optional[int] = None) -> ERC1967Proxy:
        """
        [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#22)

        Args:
            _logic: address
            _data: bytes
        """
        ...

    @overload
    @classmethod
    def deploy(cls, _logic: Union[Account, Address], _data: Union[bytearray, bytes], *, from_: Optional[Union[Account, Address, str]] = None, value: Union[int, str] = 0, gas_limit: Optional[Union[int, Literal["max"], Literal["auto"]]] = None, return_tx: Literal[False] = False, request_type: Literal["estimate"], chain: Optional[Chain] = None, gas_price: Optional[Union[int, str]] = None, max_fee_per_gas: Optional[Union[int, str]] = None, max_priority_fee_per_gas: Optional[Union[int, str]] = None, access_list: Optional[Union[Dict[Union[Account, Address, str], List[int]], Literal["auto"]]] = None, type: Optional[int] = None, block: Optional[Union[int, Literal["latest"], Literal["pending"], Literal["earliest"], Literal["safe"], Literal["finalized"]]] = None, confirmations: Optional[int] = None) -> int:
        """
        [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#22)

        Args:
            _logic: address
            _data: bytes
        """
        ...

    @overload
    @classmethod
    def deploy(cls, _logic: Union[Account, Address], _data: Union[bytearray, bytes], *, from_: Optional[Union[Account, Address, str]] = None, value: Union[int, str] = 0, gas_limit: Optional[Union[int, Literal["max"], Literal["auto"]]] = None, return_tx: Literal[False] = False, request_type: Literal["access_list"], chain: Optional[Chain] = None, gas_price: Optional[Union[int, str]] = None, max_fee_per_gas: Optional[Union[int, str]] = None, max_priority_fee_per_gas: Optional[Union[int, str]] = None, access_list: Optional[Union[Dict[Union[Account, Address, str], List[int]], Literal["auto"]]] = None, type: Optional[int] = None, block: Optional[Union[int, Literal["latest"], Literal["pending"], Literal["earliest"], Literal["safe"], Literal["finalized"]]] = None, confirmations: Optional[int] = None) -> Tuple[Dict[Address, List[int]], int]:
        """
        [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#22)

        Args:
            _logic: address
            _data: bytes
        """
        ...

    @overload
    @classmethod
    def deploy(cls, _logic: Union[Account, Address], _data: Union[bytearray, bytes], *, from_: Optional[Union[Account, Address, str]] = None, value: Union[int, str] = 0, gas_limit: Optional[Union[int, Literal["max"], Literal["auto"]]] = None, return_tx: Literal[True], request_type: Literal["tx"] = "tx", chain: Optional[Chain] = None, gas_price: Optional[Union[int, str]] = None, max_fee_per_gas: Optional[Union[int, str]] = None, max_priority_fee_per_gas: Optional[Union[int, str]] = None, access_list: Optional[Union[Dict[Union[Account, Address, str], List[int]], Literal["auto"]]] = None, type: Optional[int] = None, block: Optional[Union[int, Literal["latest"], Literal["pending"], Literal["earliest"], Literal["safe"], Literal["finalized"]]] = None, confirmations: Optional[int] = None) -> TransactionAbc[ERC1967Proxy]:
        """
        [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#22)

        Args:
            _logic: address
            _data: bytes
        """
        ...

    @classmethod
    def deploy(cls, _logic: Union[Account, Address], _data: Union[bytearray, bytes], *, from_: Optional[Union[Account, Address, str]] = None, value: Union[int, str] = 0, gas_limit: Optional[Union[int, Literal["max"], Literal["auto"]]] = None, return_tx: bool = False, request_type: RequestType = "tx", chain: Optional[Chain] = None, gas_price: Optional[Union[int, str]] = None, max_fee_per_gas: Optional[Union[int, str]] = None, max_priority_fee_per_gas: Optional[Union[int, str]] = None, access_list: Optional[Union[Dict[Union[Account, Address, str], List[int]], Literal["auto"]]] = None, type: Optional[int] = None, block: Optional[Union[int, Literal["latest"], Literal["pending"], Literal["earliest"], Literal["safe"], Literal["finalized"]]] = None, confirmations: Optional[int] = None) -> Union[bytearray, ERC1967Proxy, int, Tuple[Dict[Address, List[int]], int], TransactionAbc[ERC1967Proxy]]:
        """
        [Source code](file:///Users/upalc/Documents/woke/examples/counter/node_modules/%40openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol#22)

        Args:
            _logic: address
            _data: bytes
        """
        return cls._deploy(request_type, [_logic, _data], return_tx, ERC1967Proxy, from_, value, gas_limit, {}, chain, gas_price, max_fee_per_gas, max_priority_fee_per_gas, access_list, type, block, confirmations)

    @classmethod
    def get_creation_code(cls) -> bytes:
        return cls._get_creation_code({})

