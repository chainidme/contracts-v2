// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { IAttributes } from "./../interfaces/IAttributes.sol";

abstract contract Attributes is IAttributes {
    using SafeMath for uint;

    // hash(from, name) => Attribute
    mapping (bytes32 => Attribute) public attributes;

    function setAttribute(bytes32 name, bytes32 value, uint validForSeconds) 
        public
    {
        Attribute storage attr = attributes[_attrHash(msg.sender, name)];

        attr.validity = block.timestamp.add(validForSeconds);
        attr.value = value;

        emit AttributeAdded(msg.sender, name, attr.value, attr.validity);
    }

    function revokeAttribute(bytes32 name) 
        external 
    {
        Attribute storage attr = attributes[_attrHash(msg.sender, name)];

        attr.validity = block.timestamp;
        emit AttributeRevoked(msg.sender, name, attr.value);
    }

    /* ========== View functions ========== */

    function verifyAttribute(address from, bytes32 name, bytes32 value)
        external
        view
        returns(bool result)
    {
        Attribute memory attr = attributes[_attrHash(from, name)];
        return (value == attr.value) && (attr.validity < block.timestamp); 
    }

    function _attrHash(address from, bytes32 name)
        internal
        pure
        returns(bytes32)
    {
        return keccak256(abi.encodePacked(from, name));
    }

    function getAttribute(address from, bytes32 name)
        external
        view
        returns(Attribute memory)
    {
        return attributes[_attrHash(from, name)];
    }
}