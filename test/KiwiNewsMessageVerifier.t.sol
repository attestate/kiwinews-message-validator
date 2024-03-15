// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { Message, KNMessageVerifier } from "../src/KNMessageVerifier.sol";

contract KiwiNewsMessageVerifierTest is Test {
  function testVerify() public {
    string memory title = "Kiwistand is live";
    string memory href = "https://warpcast.com/timdaub/0x1f54f8";
    string memory _type = "amplify";
    uint256 timestamp = 1681486433;
    bytes32 r = 0xf8c2812975e8597b1d26c3f75d1aa69e7df7fb3477e3102f320aaf58d8b2d254;
    bytes32 s = 0x677d0c9a8d4645ebf0fc629957f690a0fd2da5e6bf48124ccd3c803ea5e6ad3d;
    uint8 v = 0x1b; 
    address signer = 0xee324c588ceF1BF1c1360883E4318834af66366d;

    Message memory message = Message(title, href, _type, timestamp);
    address recoveredSigner = KNMessageVerifier.verify(message, v, r, s);
    assertEq(recoveredSigner, signer);
  }
}
