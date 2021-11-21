// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPeers {
    function stakePeer(address _peer) external;

    function unstakePeer(address _peer) external;

    event PeerStaked(address _peer);
    event PeerUnstaked(address peer);
}