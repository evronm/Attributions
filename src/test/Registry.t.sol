
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Attestations.t.sol";

contract RegistryTest is ExtendedDSTest {
  Registry registry;
  FreeForm freeform;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    freeform = new FreeForm("freeformtest", address(0));
    registry = new Registry("test", address(0));
  }
  function testRegisterRegistry() public{
    Registry r = new Registry("test1", address(registry));
    r.registry().register_registry(r);
  }
  function testFailDuplicateName() public {
    Registry r = new Registry("test1", address(registry));
    r.registry().register_registry(r);
    r.registry().register_registry(r);
  }
  function testTree() public{
    Registry r = new Registry("test1", address(registry));
    Registry r1 = new Registry("test1", address(registry));
    Registry r2 = new Registry("test1", address(registry));
    Registry r11 = new Registry("test1", address(r1));
    Registry r12 = new Registry("test1", address(r1));
    Registry r21 = new Registry("test1", address(r2));
    Registry r22 = new Registry("test1", address(r2));
  }
}
