// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./extend_ds_test.sol";
import "src/Attestations.sol";

contract AttestationTest is ExtendedDSTest {
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  kv[] kvs;
  string[] tags;

  function testFailEmptyAttestation() public {
    new Attestation().init(kvs,tags);
  }
  function testFailDupPropName() public {
    kvs.push(kv("Name", "test"));
    kvs.push(kv("Name", "test"));
    new Attestation().init(kvs,tags);
  }
  
  function testNameOnly() public {
    kvs.push(kv("Name", "test"));
    new Attestation().init(kvs,tags);
  }
  function testSeveralProps() public {
    kvs.push(kv("Name", "test"));
    kvs.push(kv("Place", "test place"));
    kvs.push(kv("Date", "test date"));
    kvs.push(kv("Event", "test event"));
    Attestation a=new Attestation().init(kvs,tags);
    assertEq(4,a.props().length);
    assert(stringEq("Name", a.props()[0].key));
    assert(stringEq("test", a.props()[0].value));
    assert(stringEq("Event", a.props()[3].key));
    assert(stringEq("test event", a.props()[3].value));
  }
  function testAttestation() public {
    kvs.push(kv("Name", "test"));
    Attestation a=new Attestation().init(kvs,tags);
    cheats.startPrank(address(10));
    a.attest(address(1));
    a.attest(address(2));
    a.attest(address(3));
    cheats.expectRevert(bytes("Attestation already exists."));
    a.attest(address(3));
    cheats.stopPrank();

    assertEq(a.attestors().length,1);
    assertEq(a.attestees().length,3);
    assertEq(a.attestations_about(address(1)).length,1);

    assertEq(a.attestations_by(address(10)).length,3);

    cheats.startPrank(address(1));
    a.attest(address(3));
    a.attest(address(4));
    cheats.expectRevert(bytes("Attestation already exists."));
    a.attest(address(3));
    cheats.stopPrank();

    assertEq(a.attestors().length,2);
    assertEq(a.attestees().length,4);
    assertEq(a.attestations_about(address(3)).length,2);
  }
  function testTags() public {
    kvs.push(kv("Name", "test"));
    tags.push("test");
    tags.push("test2");
    Attestation a=new Attestation().init(kvs,tags);
    assertEq(2,a.tags().length);
    assert(stringEq("test", a.tags()[0]));
    assert(stringEq("test2", a.tags()[1]));

  }
}