// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { NTCredential } from "./../utils/NonTransferrable/NTCredential.sol";

contract Credentials is NTCredential {
    constructor() 
    NTCredential("Verifiable Credential", "CRED", "https://chainid.me/token/"){}
}