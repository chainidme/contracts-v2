// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IdentityInterface {

    function owner() view external returns(address);

    // owner could staking peer-to-peer relationships
    function stakePeer(address _peer) external;

    // anyone could add attributes to this identity
    function addAttribute(string memory _attribute) external;

    // verify attribute
    function verifyAttribute(string memory _attribute, address _user) external view returns(bool);

    // remove attribute
    function removeAttribute(string memory _attribute) external;

    // unstake peer
    function unstakePeer(address _peer) external;

    // Issue verifiable credentials
    function issueCredential(address recipient, string memory _credentialURI) external returns (uint256);

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function credentialURI(uint256 tokenId) external view returns (string memory);

    /* ========== Events ========== */
    
}