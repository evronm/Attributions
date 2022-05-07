// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Registry is Initializable {
  string[] public _registries_names;
  mapping (string => address) public _registries;
  string[] public _attestation_strings;
  mapping (string => address) public _attestations;

  string public name;

  function init (string memory name_) public initializer returns (Registry) {
    name=name_;
    return this;
  }

  function attestations (string memory attestation_string) public view returns (address){ return _attestations[attestation_string]; }
  function attestation_strings () public view returns (string[] memory){ return _attestation_strings; }
  function registries (string memory child_name) public view returns (address){ return _registries[child_name]; }
  function registries_names () public view returns (string[] memory){ return _registries_names; }

  function register_in_parent(Registry parent) public {
    parent.register_registry(this);
  }


  function register_registry(Registry child) public {
    require (registries(child.name())==address(0), "This registry is already registered");
    _registries_names.push(child.name());
    _registries[child.name()]=address(child);
  
  }
  //using attestation string as unique here; eliminates the need for a registration function for each attestation class.
  function register_attestation(string memory attestation, address child) public {
    require (attestations(attestation)==address(0), "This attestation is already registered");
    _attestation_strings.push(attestation);
    _attestations[attestation]=child;
  
  }
}
