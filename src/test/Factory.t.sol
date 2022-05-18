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
  function testFailDupName() public {
    kvs.push(kv("Name", "test"));
    kv[] memory mem_kvs=kvs; // can't convert storage pointer to memory array
    string[] memory mem_tags;
    factory.create_attestation(mem_kvs, mem_tags);
    factory.create_attestation(mem_kvs, mem_tags);
  }
  function testFailDupTag() public {
    factory.create_tag("test");
    factory.create_tag("test");
  }
  function testAttestation() public {
    kvs.push(kv("Name", "test"));
    kv[] memory mem_kvs=kvs; // can't convert storage pointer to memory array
    string[] memory mem_tags;
    Attestation a=factory.create_attestation(mem_kvs, mem_tags);
    assertEq(0, factory.tags().length);
    assertEq(0, a.tags().length);
    assert(stringEq("Name", a.props()[0].key));
    assert(stringEq("test", a.props()[0].value));

  }
  function testMuliPropMultiTagAttestation() public {
    kvs.push(kv("Name", "test"));
    kvs.push(kv("Place", "test place"));
    kvs.push(kv("Date", "test date"));
    kv[] memory mem_kvs=kvs; // can't convert storage pointer to memory array
    tags.push("tag1");
    tags.push("tag2");
    tags.push("tag3");
    tags.push("tag4");
    string[] memory mem_tags=tags;
    Attestation a=factory.create_attestation(mem_kvs, mem_tags);
    assertEq(3, a.props().length);
    assertEq(4, a.tags().length);
    assertEq(4, factory.tags().length);
    assert(stringEq("tag1", a.tags()[0]));
    assert(stringEq("tag1", factory.tags()[0].tag));
    assertEq(Kvs.get_value_from_key(a.props(), "Name"), factory.tags()[0].names[0]);

    assert(stringEq("tag4", a.tags()[3]));
    assert(stringEq("tag4", factory.tags()[3].tag));
    assertEq(Kvs.get_value_from_key(a.props(), "Name"), factory.tags()[3].names[0]);

    kvs[0].value="test1";
    mem_kvs=kvs;
    Attestation b=factory.create_attestation(mem_kvs, mem_tags);
    assertEq(4, factory.tags().length);
    assertEq(Kvs.get_value_from_key(b.props(), "Name"), factory.tags()[0].names[1]);

    kvs[0].value="test2";
    mem_kvs=kvs;
    tags.push("tag5");
    mem_tags=tags;
    Attestation c=factory.create_attestation(mem_kvs, mem_tags);
    assertEq(5, factory.tags().length);
    assertEq(Kvs.get_value_from_key(c.props(),"Name"), factory.tags()[0].names[2]);
    assertEq(Kvs.get_value_from_key(c.props(),"Name"), factory.tags()[4].names[0]);

  }
}