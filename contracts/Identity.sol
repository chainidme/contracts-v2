// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { NTOwnership } from "./utils/NonTransferrable/NTOwnership.sol";
import { Counters } from "@openzeppelin/contracts/utils/Counters.sol";
import { IRegistry } from "./interfaces/IRegistry.sol";
import { MultiSigWallet } from "./identity/MultiSigWallet.sol";
import { Credentials } from "./identity/Credentials.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
/// @notice You can use this identity to verify
/// @dev All function calls are currently implemented without side effects
contract Identity is 
    NTOwnership, 
    MultiSigWallet, 
    Credentials
{

    using Counters for Counters.Counter;
    
    // attribute => (attribute, from, to)
    mapping(bytes32 => bool) public attributes; 
    // array of staked peers
    mapping(address => bool) public peerStake;

    bytes32 public id;

    constructor(bytes32 _id) 
    MultiSigWallet(tx.origin)
    {
        id = _id;
    }

    /* ========== Attributes ========== */
    
    /// @notice Anyone could add attributes to this identity
    function addAttribute(string memory _attribute) external {
        attributes[keccak256(abi.encodePacked(_attribute, msg.sender))] = true;
    }

    /// @notice Verify attribute
    function verifyAttribute(string memory _attribute, address _user) 
    external view returns(bool){
        return attributes[keccak256(abi.encodePacked(_attribute, _user))];
    }

    /// @notice Remove attribute
    function removeAttribute(string memory _attribute) external {
        require( attributes[keccak256(abi.encodePacked(_attribute, msg.sender))] == true, 
            "Attribute not found");

        attributes[keccak256(abi.encodePacked(_attribute, msg.sender))] = false;
    }

    /* ========== Peers ========== */

    /// @notice Owner could staking peer-to-peer relationships
    function stakePeer(address _peer) external onlyOwner {
        peerStake[_peer] = true;
    }

    /// @notice Unstake peer
    function unstakePeer(address _peer) external onlyOwner {
        peerStake[_peer] = false;
    }
}