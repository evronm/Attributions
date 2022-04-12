// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./extend_ds_test.sol";
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
  function testRegFactoryTree() public {
    Registry r1=factory.create_registry("r1",address(0));
    Registry r11=factory.create_registry("r11",address(r1));
    Registry r12=factory.create_registry("r12",address(r1));
    Registry r13=factory.create_registry("r13",address(r1));
    assertEq(3, r1.children_names().length);
    assertEq(address(r11), r1.children("r11"));
    assertEq(address(r12), r1.children(r12.name()));
    assertEq(address(r13), r1.children(r13.name()));
  }
}
