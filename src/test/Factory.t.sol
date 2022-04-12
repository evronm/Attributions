
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Attestations.t.sol";
import "../Factory.sol";

contract FactoryTest is ExtendedDSTest {
  Factory factory;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    factory=new Factory().init();
  }
  function testRegistryFactory() public{
    Registry test_reg=factory.create_registry("test", address(0));
    assertTrue(stringEq("test",test_reg.name()));
  }
}
