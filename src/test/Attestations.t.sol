// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./extend_ds_test.sol";
import "src/Attestations.sol";

// Using FrreForm to test abstract base class funtionality
contract FreeFormAttestationTest is ExtendedDSTest {
  FreeForm freeform;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    freeform = new FreeForm().init("freeformtest");
  }

  function testAttestationString() public {
    assertTrue(stringEq("freeformtest",freeform.attestation()));
  }

  function testEverythingEmpty() public {
    assertEq(freeform.attestations_by(address(1)).length,0);
    assertEq(freeform.attestations_about(address(1)).length,0);
    assertEq(freeform.attestors().length,0);
    assertEq(freeform.attestees().length,0);
  }

  function testAttestation() public {
    cheats.startPrank(address(10));
    freeform.attest(address(1));
    freeform.attest(address(2));
    freeform.attest(address(3));
    cheats.expectRevert(bytes("Attestation already exists."));
    freeform.attest(address(3));
    cheats.stopPrank();

    assertEq(freeform.attestors().length,1);
    assertEq(freeform.attestees().length,3);
    assertEq(freeform.attestations_about(address(1)).length,1);

    assertEq(freeform.attestations_by(address(10)).length,3);

    cheats.startPrank(address(1));
    freeform.attest(address(3));
    freeform.attest(address(4));
    cheats.expectRevert(bytes("Attestation already exists."));
    freeform.attest(address(3));
    cheats.stopPrank();

    assertEq(freeform.attestors().length,2);
    assertEq(freeform.attestees().length,4);
    assertEq(freeform.attestations_about(address(3)).length,2);
  }
}

contract AttendanceAttestationTest is ExtendedDSTest {
  Attendance attendance;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    attendance = new Attendance().init("test event","test place", "test date");
  }
  function testAttestationString() public {
    assertTrue(stringEq(attendance.attestation(), "name: test event\nplace: test place\ndate: test date"));
  }
}
