// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Registry {
  string[] public _children_names;
  mapping (string => address) public _children;
  string[] public _attestation_strings;
  mapping (string => address) public _attestations;

  string public name;

  constructor(string memory name_) {
    name=name_;
  }

  function attestations (string memory attestation_string) public view returns (address){ return _attestations[attestation_string]; }
  function attestation_strings () public view returns (string[] memory){ return _attestation_strings; }
  function children (string memory child_name) public view returns (address){ return _children[child_name]; }
  function children_names () public view returns (string[] memory){ return _children_names; }

  function register_in_parent(Registry parent) public {
    parent.register_registry(this);
  }


  function register_registry(Registry child) public {
    require (children(child.name())==address(0), "This registry is already registered");
    _children_names.push(child.name());
    _children[child.name()]=address(child);
  
  }
  //using attestation string as unique here; eliminates the need for a registration function for each attestation class.
  function register_attestation(string memory attestation, address child) public {
    require (attestations(attestation)==address(0), "This attestation is already registered");
    _attestation_strings.push(attestation);
    _attestations[attestation]=child;
  
  }
}
