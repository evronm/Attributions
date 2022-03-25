// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "src/Attestations.sol";

interface CheatCodes {
    function prank(address) external;
      function expectRevert(bytes calldata) external;
}

contract FreeFormAttestationTest is DSTest {
  FreeForm freeform;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
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

  function testAttestation() public {
    freeform.attest(address(1));
    freeform.attest(address(2));
    freeform.attest(address(3));
    cheats.expectRevert(bytes("Attestation already exists."));
    freeform.attest(address(3));

    assertEq(freeform.attestors().length,1);
    assertEq(freeform.attestees().length,3);
  }
  //This needs to go in ds-test
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
}
