
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Attestations.t.sol";

contract RegistryTest is ExtendedDSTest {
  Registry registry;
  FreeForm freeform;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    freeform = new FreeForm("freeformtest");
    registry = new Registry("test");
  }
  function testRegisterRegistry() public{
    Registry r = new Registry("test1");
    registry.register_registry(r);
    assertEq(registry.children_names().length,1);
  }
  function testFailDuplicateName() public {
    Registry r = new Registry("test1");
    registry.register_registry(r);
    registry.register_registry(r);
  }
  function testTree() public{
/*    Registry r1 = new Registry("test2", address(registry)).register_in_parent();
    Registry r2 = new Registry("test3", address(registry)).register_in_parent();
    Registry r11 = new Registry("test11", address(r1)).register_in_parent();
    Registry r12 = new Registry("test12", address(r1)).register_in_parent();
    Registry r21 = new Registry("test21", address(r2)).register_in_parent();
    Registry r22 = new Registry("test22", address(r2)).register_in_parent();
    Registry r23 = new Registry("test23", address(r2)).register_in_parent();

    assertEq(registry.children_names().length,2);
    assertEq(r1.children_names().length,2);
    assertEq(r2.children_names().length,3);
   */
  }
}
