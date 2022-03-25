// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "src/Attestations.sol";


contract FreeFormAttestationTest is DSTest {
  FreeForm freeform;
  function setUp() public {
    freeform = new FreeForm("freeformtest");
  }

  function testAttestationString() public {
    assertTrue(compareStrings("freeformtest",freeform.attestation()));
  }

  function testEverythingEmpty() public {
    assertEq(freeform.attestations_by(address(1)).length,0);
    assertEq(freeform.attestations_about(address(1)).length,0);
    assertEq(freeform.attestors().length,0);
    assertEq(freeform.attestees().length,0);
  }

  //This needs to go in ds-test
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
}
