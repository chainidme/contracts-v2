// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IPeers } from "./../interfaces/IPeers.sol";

abstract contract Peers is IPeers {

    mapping (address => bool) peerStake;

    /// @notice Owner could staking peer-to-peer relationships
    function stakePeer(address _peer) external onlyOwner {
        peerStake[_peer] = true;
        emit PeerStaked(_peer);
    }

    /// @notice Unstake peer
    function unstakePeer(address _peer) external onlyOwner {
        peerStake[_peer] = false;
        emit PeerUnstaked(_peer);
    }

    modifier onlyOwner() virtual;
}