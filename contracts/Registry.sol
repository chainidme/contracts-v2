// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Identity } from "./Identity.sol";
import { IdentityInterface } from "./interfaces/IdentityInterface.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";

contract Registry is Ownable, Pausable {

    // contract address => identity mapping
    mapping(bytes32 => address) public identity;

    uint registryFee;

    constructor(uint _registryFee) {
        registryFee = _registryFee;
    }

    function updateFee(uint newRegistryFee) external onlyOwner {
        registryFee = newRegistryFee;
    }

    // registering new identity
    function newIdentity(bytes32 _id) external payable {
        require(msg.value >= registryFee, "Payment: Registry Fee required");

        Identity id = new Identity(_id);
        id.transferOwnership(msg.sender);

        identity[_id] = address(id);
    }
    
    function getIdentity(bytes32 _user) view public returns(address){
        return IdentityInterface(identity[_user]).owner();
    }
}