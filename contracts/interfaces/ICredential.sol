// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICredential {
    
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function setBaseURI(string memory _newBaseURI) external;

    function issueCredential(address to, uint _validity) external;

    function revokeCredential(uint _credentialId) external;

    function verifyCredential(uint _credentialId, address to) external view returns(bool);
}