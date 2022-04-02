// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Registry {
  string[] public _registry_names;
  mapping (string => address) public _registries;
  string[] public _attestation_strings;
  mapping (string => address) public _contracts;

  string public name;
  Registry public registry;

  constructor(string memory name_, address registry_addr) {
    name=name_;
    if (registry_addr > address(0)) {
      registry=Registry(registry_addr);
      registry.register_registry(this);
    }
  }

  function contracts (string memory attestation_string) public view returns (address){ return _contracts[attestation_string]; }
  function attestation_strings () public view returns (string[] memory){ return _attestation_strings; }
  function registries (string memory registry_name) public view returns (address){ return _registries[registry_name]; }
  function registry_names () public view returns (string[] memory){ return _registry_names; }
  
  function register_registry(Registry child) public {
    require (registries(child.name())==address(0), "This registry is already registered");
    _registry_names.push(child.name());
    _registries[child.name()]=address(child);
  
  }
  function register_attestation() public {
  
  }
}
