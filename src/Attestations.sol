// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./Common.sol";

contract AttestationList is Initializable {

  kv[] public _props; 

  mapping (address => address[]) public _attestations_by;
  mapping (address => address[]) public _attestations_about;
  address[] public _attestors;
  address[] public _attestees;

  function init (kv[] calldata props_) public initializer returns (AttestationList) {
    require (Kvs.get_index_from_key(props_, "Name") > -1, "Name required" );
    //This is the only way to do this for now; EVM does not allow transfer of structures in memory to storage
    //Plus, it allows for a dups check.
    for (uint i=0; i< props_.length; i++) {
      require (Kvs.get_index_from_key(_props, props_[i].key) == -1, "Duplicate Property name given");
      _props.push(props_[i]);
    }
    return this;
  }
  function props () public view returns (kv[] memory) { return  _props; }

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
/*
contract FreeForm is AttestationList, Initializable { 
  string private _attestation;
  function init (string memory attestation_) public initializer returns (FreeForm) {
    _attestation=attestation_;
    return this;
  }
  function attestation () public view returns (string memory) {
    return  _attestation;
  }
}

contract Attendance is AttestationList, Initializable {
  struct event_details {
    string name;
    string place;
    string date;
  }
  event_details private _attestation;
  function init (string memory name,string memory place,string memory date) public initializer returns (Attendance) {
    _attestation.name=name;
    _attestation.place=place;
    _attestation.date=date;
    return this;
  }

  function attestation () public view returns (string memory) {
    return  string(string.concat("name: ", bytes(_attestation.name), "\n", "place: ", bytes(_attestation.place),"\n", "date: ", bytes(_attestation.date)));
  }
}
*/