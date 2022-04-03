
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
    Registry r1 = new Registry("test1", address(registry));
    r1.registry().register_registry(r1);
  }
}
