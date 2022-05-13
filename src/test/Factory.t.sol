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
  function testFailDupRegistries() public {
    factory.create_registry("test", address(0));
    factory.create_registry("test", address(0));
  }
  function testRegFactoryTree() public {
    Registry r1=factory.create_registry("r1",address(0));
    Registry r11=factory.create_registry("r11",address(r1));
    Registry r12=factory.create_registry("r12",address(r1));
    Registry r13=factory.create_registry("r13",address(r1));
    assertEq(3, r1.registries().length);
    assertEq(address(r11), Regs.get_address_from_string(r1.registries(), "r11"));
    assertEq(address(r12), Regs.get_address_from_string(r1.registries(),r12.name()));
    assertEq(address(r13), Regs.get_address_from_string(r1.registries(),r13.name()));

    assertEq(1,factory.registries().length);
    assertEq(r1.name(), factory.registries()[0].name);
    assertEq(address(r1), factory.registries()[0].addy);
  }
  
  /*
  function testFreeFormFactory() public {
    Registry r1=factory.create_registry("r1",address(0));
    FreeForm ff=factory.create_free_form("test",address(0));
    assert(stringEq("test",ff.attestation()));
    
    FreeForm ff2=factory.create_free_form("test",address(r1));
    assertEq(1, r1.attestations().length);
    assertEq(address(ff2),Regs.get_address_from_string(r1.attestations(), "test"));
  }
  function testAttendanceFactory() public {
    Registry r1=factory.create_registry("r1",address(0));
    Attendance att=factory.create_attendance("name","place","date",address(0));
    assertTrue(stringEq(att.attestation(), "name: name\nplace: place\ndate: date"));

    Attendance att2=factory.create_attendance("name","place","date",address(r1));
    assertEq(1, r1.attestations().length);
    assertEq(address(att2),Regs.get_address_from_string(r1.attestations(), "name: name\nplace: place\ndate: date"));
  }
  */
}
