// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import { NTCredential } from "./../utils/NonTransferrable/NTCredential.sol";

// contract Credentials is NTCredential {
//     constructor()
//     NTCredential("Verifiable Credential", "CRED", "https://chainid.me/token/"){}
// }

import { ERC721, IERC721Metadata, IERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ICredential } from "../interfaces/ICredential.sol";
import { Counters } from "@openzeppelin/contracts/utils/Counters.sol";

/// @title Non Transferable Verifible Credential
/// @author Prasad Kumkar - <prasad@chainid.me>
abstract contract Credentials is ERC721, Ownable, ICredential {

    using Counters for Counters.Counter;
    Counters.Counter private _credentialIds;

    mapping (uint => uint) public validity;

    string public baseURI;

    constructor(string memory name, string memory symbol) 
    ERC721(name, symbol) 
    {}

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        virtual 
        override(ERC721, ICredential) 
        returns (bool)
    {
        return interfaceId == type(ICredential).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function setBaseURI(string memory _newBaseURI) 
        public onlyOwner
    {
        baseURI = _newBaseURI;
    }


    function issueCredential(address to, uint _validity) 
        external onlyOwner
    {
        _credentialIds.increment();

        uint256 newCredentialId = _credentialIds.current();
        _mint(to, newCredentialId);

        validity[newCredentialId] = _validity;
    }

    function revokeCredential(uint _credentialId)
        external onlyOwner
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