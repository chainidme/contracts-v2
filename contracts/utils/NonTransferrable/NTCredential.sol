// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC721, IERC721Metadata, IERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { IAccessControl } from "@openzeppelin/contracts/access/IAccessControl.sol";
import { Counters } from "@openzeppelin/contracts/utils/Counters.sol";

/// @title Non Transferable Verifible Credential
/// @author Prasad Kumkar - <prasad@chainid.me>
contract NTCredential is ERC721, AccessControl {
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 public constant BASEURI_SETTER_ROLE = keccak256(
        "BASEURI_SETTER_ROLE"
    );

    using Counters for Counters.Counter;
    Counters.Counter private _credentialIds;

    mapping (uint => uint) public validity;

    string public baseURI;

    constructor(string memory name, string memory symbol, string memory __baseURI) 
    ERC721(name, symbol) 
    {
        grantRole(ISSUER_ROLE, msg.sender);
        grantRole(BASEURI_SETTER_ROLE, msg.sender);

        setBaseURI(__baseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        virtual 
        override(AccessControl, ERC721) 
        returns (bool)
    {
        return interfaceId == type(IAccessControl).interfaceId || 
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        virtual
        override(ERC721)
    {
        require(from == address(0) || to == address(0), "NTCredential: Credential is non transferrable");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function setBaseURI(string memory _newBaseURI) 
        public 
    {
        require(
            hasRole(BASEURI_SETTER_ROLE, msg.sender),
            "NTCredential: Account does not have setter role"
        );
        baseURI = _newBaseURI;
    }


    function issueCredential(address to, uint _validity) 
        external 
    {
        require(
            hasRole(ISSUER_ROLE, msg.sender),
            "NTCredential: Account does not have issuer role"
        );
        _credentialIds.increment();

        uint256 newCredentialId = _credentialIds.current();
        _mint(to, newCredentialId);

        validity[newCredentialId] = _validity;
    }

    function revokeCredential(uint _credentialId)
        external
    {
        require(_isApprovedOrOwner(msg.sender, _credentialId), "NTCredential: caller is not owner nor approved");
        _burn(_credentialId);
    }

    function verifyCredential(uint _credentialId, address to)
        external view
        returns(bool)
    {
        return _isApprovedOrOwner(to, _credentialId) && validity[_credentialId] < block.timestamp;
    }
}