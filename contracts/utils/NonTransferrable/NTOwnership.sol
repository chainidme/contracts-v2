// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract NTOwnership is Ownable {
    function transferOwnership(address newOwner) public virtual override {
        require(newOwner == address(0), "NTOwnership: Identity is non transferable");
    }
}