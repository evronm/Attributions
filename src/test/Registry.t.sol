// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./extend_ds_test.sol";
import "../Attestations.sol";
import "../Registry.sol";

contract RegistryTest is ExtendedDSTest {
  Registry registry;
  FreeForm freeform;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    freeform = new FreeForm().init("freeformtest");
    registry = new Registry().init("test");
  }
  function testRegisterRegistry() public{
    Registry r = new Registry().init("test1");
    registry.register_registry(r);
    assertEq(registry.registries_names().length,1);
  }
  //also tests register_in_parent
  function testFailDuplicateName() public {
    Registry r = new Registry().init("test1");
    r.register_in_parent(registry);
    registry.register_registry(r);
  }
  function testTree() public{
    Registry r1 = new Registry().init("test2");
    Registry r2 = new Registry().init("test3");
    Registry r11 = new Registry().init("test11");
    Registry r12 = new Registry().init("test12");
    Registry r21 = new Registry().init("test21");
    Registry r22 = new Registry().init("test22");
    Registry r23 = new Registry().init("test23");
    registry.register_registry(r1);
    registry.register_registry(r2);
    r11.register_in_parent(r1);
    r12.register_in_parent(r1);
    r21.register_in_parent(r2);
    r22.register_in_parent(r2);
    r23.register_in_parent(r2);

    assertEq(registry.registries_names().length,2);
    assertEq(r1.registries_names().length,2);
    assertEq(r2.registries_names().length,3);

    assertTrue(stringEq(registry.registries_names()[0],r1.name()));
    assertTrue(stringEq(registry.registries_names()[1],r2.name()));
    assertTrue(stringEq(r1.registries_names()[0],r11.name()));
    assertTrue(stringEq(r2.registries_names()[2],r23.name()));
  }

  function testAttestationRegistry() public {
    registry.register_attestation(freeform.attestation(),address(freeform));
    assertEq(registry.attestation_strings().length, 1);
    assertEq(registry.attestations(freeform.attestation()),address(freeform));
  }

  function testFailDupAttestation() public {
    registry.register_attestation(freeform.attestation(),address(freeform));
    registry.register_attestation(freeform.attestation(),address(freeform));
  }
}
