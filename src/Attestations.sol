// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./Common.sol";

contract Attestation is Initializable {

  kv[] public _props; 
  string[] public _tags;

  mapping (address => address[]) public _attestations_by;
  mapping (address => address[]) public _attestations_about;
  address[] public _attestors;
  address[] public _attestees;

  function init (kv[] calldata props_, string[] calldata tags_) public initializer returns (Attestation) {
    require (Kvs.get_index_from_key(props_, "Name") > -1, "Name required" );
    //This is the only way to do this for now; EVM does not allow transfer of structures in memory to storage
    //Plus, it allows for a dups check.
    for (uint i=0; i< props_.length; i++) {
      require (Kvs.get_index_from_key(_props, props_[i].key) == -1, "Duplicate Property name given");
      _props.push(props_[i]);
    }
    for (uint i=0; i< tags_.length; i++) {
      _tags.push(tags_[i]);
    }
    return this;
  }
  function props () public view returns (kv[] memory) { return  _props; }
  function tags () public view returns (string[] memory) { return  _tags; }

  function attestations_by (address attestor) public view returns (address[] memory){ return _attestations_by[attestor]; }
  function attestations_about (address attestee) public view returns (address[] memory){ return _attestations_about[attestee]; }
  function attestors () public view returns (address[] memory){ return _attestors; }
  function attestees () public view returns (address[] memory){ return _attestees; }

  function attest(address about_addr) public {
    require (find_redundant(about_addr) == false, "Attestation already exists.");
    if (attestations_by(msg.sender).length==0) {
      _attestors.push(msg.sender);
    }
    if (attestations_about(about_addr).length==0) {
      _attestees.push(msg.sender);
    }
    _attestations_by[msg.sender].push(about_addr);
    _attestations_about[about_addr].push(msg.sender);
  }

  function find_redundant (address about_addr) internal view returns (bool){
    address[] memory attestations_by_sender=_attestations_by[msg.sender];
    for (uint i=0; i < attestations_by_sender.length; i++) {
        if (attestations_by_sender[i] == about_addr) {
            return true;
        }
    }
    return false;
  }

}