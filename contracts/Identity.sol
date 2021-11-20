// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { IRegistry } from "./interfaces/IRegistry.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { MultiSigWallet } from "./identity/MultiSigWallet.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
/// @notice You can use this identity to verify
/// @dev All function calls are currently implemented without side effects
contract Identity is Ownable, ERC721, MultiSigWallet {

    using Counters for Counters.Counter;
    Counters.Counter private _credentialIds;
    
    using Strings for uint256;

    // Optional mapping for credential URIs
    mapping(uint256 => string) private _credentialURIs;
    // attribute => (attribute, from, to)
    mapping(bytes32 => bool) public attributes; 
    // array of staked peers
    mapping(address => bool) public peerStake;

    bytes32 public id;

    constructor(bytes32 _id) 
    ERC721("ChainID Credential", "CRED") 
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

    /* ========== Credentials ========== */

    /// @notice Issue verifiable credentials
    function issueCredential(address recipient, string memory _credentialURI) 
    external returns (uint256) 
    {
        return _issueCredential(recipient, _credentialURI);
    }

    function revokeCredential(uint credentialId) 
    external 
    {
        _burn(credentialId);
    }

    function verifyCredential(address to, uint credentialId) 
    external view returns(bool) 
    {
        return ownerOf(credentialId) == to;
    }

    function _issueCredential(address recipient, string memory _credentialURI) 
    internal virtual returns (uint256) {
        _credentialIds.increment();

        uint256 newItemId = _credentialIds.current();
        _mint(recipient, newItemId);
        _setCredentialURI(newItemId, _credentialURI);

        return newItemId;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function credentialURI(uint256 tokenId) public view virtual returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _credentialURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setCredentialURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _credentialURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_credentialURIs[tokenId]).length != 0) {
            delete _credentialURIs[tokenId];
        }
    }
}