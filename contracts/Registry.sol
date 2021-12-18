// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Identity } from "./Identity.sol";
import { IdentityInterface } from "./interfaces/IdentityInterface.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";

contract Registry is Ownable, Pausable {

    // uint constant MAX_ID_LENGTH = 255;

    // contract identity => address mapping
    mapping(bytes32 => address) public ownerOf;

    uint[] registryFee = [0, 10**22, 10**21, 10**20, 10**20, 10**19, 10**19];

    // constructor() {}


    function updateFee(uint newRegistryFee, uint index) external onlyOwner {
        registryFee[index] = newRegistryFee;
    }

    // registering new identity
    function newIdentity(bytes memory _id) external payable {
        uint requiredFee;
        if(_id.length > 6) requiredFee = registryFee[_id.length];
        else requiredFee = 10**18;
        
        require(msg.value >= requiredFee, "Payment: Registry Fee required");

        bytes32 _identity = keccak256(_id);
        Identity id = new Identity(_identity);
        id.setBaseURI(string(_id));
        id.transferOwnership(msg.sender);

        ownerOf[_identity] = address(id);
    }
    
    function getIdentity(bytes32 _user) view public returns(address){
        return IdentityInterface(ownerOf[_user]).owner();
    }
}