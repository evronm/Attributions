// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./extend_ds_test.sol";
import "../Factory.sol";

contract FactoryTest is ExtendedDSTest {
  Factory factory;
  kv[] kvs;
  string[] tags;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    factory=new Factory().init();
  }
  function testNewTag() public {
    factory.create_tag("test");
    assertEq(1, factory.tags().length);
  }
  function testFailDupTag() public {
    factory.create_tag("test");
    factory.create_tag("test");
  }
  function testAttestation() public {
    kvs.push(kv("Name", "test"));
    kv[] memory foo=kvs; // can't convert storage pointer to memory array
    string[] memory mem_tags;
    Attestation a=factory.create_attestation(foo, mem_tags);
    assertEq(0, factory.tags().length);
    assertEq(0, a.tags().length);
    assert(stringEq("Name", a.props()[0].key));
    assert(stringEq("test", a.props()[0].value));

  }
  function testMuliPropMultiTagAttestation() public {
    kvs.push(kv("Name", "test"));
    kvs.push(kv("Place", "test place"));
    kvs.push(kv("Date", "test date"));
    kv[] memory foo=kvs; // can't convert storage pointer to memory array
    tags.push("tag1");
    tags.push("tag2");
    tags.push("tag3");
    tags.push("tag4");
    string[] memory mem_tags=tags;
    Attestation a=factory.create_attestation(foo, mem_tags);
    assertEq(3, a.props().length);
    assertEq(4, a.tags().length);
    assertEq(4, factory.tags().length);
    assert(stringEq("tag1", a.tags()[0]));
    assert(stringEq("tag1", factory.tags()[0].tag));
    assertEq(address(a), factory.tags()[0].addresses[0]);

    assert(stringEq("tag4", a.tags()[3]));
    assert(stringEq("tag4", factory.tags()[3].tag));
    assertEq(address(a), factory.tags()[3].addresses[0]);
  }
  /*function testRegistryFactory() public{
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
    assertEq(address(r11), Str_addrs.get_address_from_string(r1.registries(), "r11"));
    assertEq(address(r12), Str_addrs.get_address_from_string(r1.registries(),r12.name()));
    assertEq(address(r13), Str_addrs.get_address_from_string(r1.registries(),r13.name()));

    assertEq(1,factory.registries().length);
    assertEq(r1.name(), factory.registries()[0].name);
    assertEq(address(r1), factory.registries()[0].addy);
  }
  function testAttestationFactory() public {
    Registry r1=factory.create_registry("r1",address(0));
    kvs.push(kv("Name", "test"));
    kv[] memory foo=kvs; // can't convert storage pointer to memory array
    AttestationList a=factory.create_attestation(foo, address(0));
    assert(stringEq("test",a.props()[0].value));
    AttestationList b=factory.create_attestation(foo, address(r1));
    assertEq(1, r1.attestations().length);
    assertEq(address(b),Str_addrs.get_address_from_string(r1.attestations(), "test"));
  } */
}
