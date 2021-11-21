// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDelegation {

    function addDelegate(bytes32 delegateType, address delegate, uint validity) external;

    function revokeDelegate(bytes32 delegateType, address delegate) external;

    function validDelegate(bytes32 delegateType, address delegate) external view returns(bool);

    /* Events */
    event DelegateAdded(bytes32 delegateType, address delegate, uint validity);
    event DelegateRevoked(bytes32 delegateType, address delegate);
}