// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "src/Attestations.sol";

contract TestFreeForm is FreeForm("freeformtest") {
}

contract AttestationTest is DSTest {
  FreeForm freeform;
  function setUp() public {
    freeform = new FreeForm("freeformtest");
  }

  function testExample() public {
    freeform = new FreeForm("freeformtest");
    emit log (freeform.attestation());
    assertTrue(compareStrings("freeformtest",freeform.attestation()));
  }

  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
}
