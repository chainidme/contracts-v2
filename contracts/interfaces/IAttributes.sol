// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAttributes {

    struct Attribute {
        bytes32 value;
        uint validity;
    }

    function setAttribute(bytes32 name, bytes32 value, uint validForSeconds) external;

    function revokeAttribute(bytes32 name) external; 


    /* ========== View functions ========== */

    function verifyAttribute(address from, bytes32 name, bytes32 value) external view returns(bool result);

    function getAttribute(address from, bytes32 name) external view returns(Attribute memory);

    /* ========== Events ========== */

    event AttributeAdded(address _from, bytes32 _name, bytes32 _value, uint validity);
    event AttributeRevoked(address _from, bytes32 _name, bytes32 _value);
}