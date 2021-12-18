// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import { IRegistry } from "./interfaces/IRegistry.sol";
import { MultiSigWallet } from "./identity/MultiSigWallet.sol";
import { Credentials } from "./identity/Credentials.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
/// @notice You can use this identity to verify
/// @dev All function calls are currently implemented without side effects
contract Identity is 
    MultiSigWallet, 
    Credentials
{
    bytes32 public id;

    constructor(bytes32 _id) 
    MultiSigWallet(tx.origin)
    Credentials("Verifiable Credential", "CRED")
    {
        id = _id;
    }
}