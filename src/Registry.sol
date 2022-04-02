// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Registry {
  string[] public _attestation_strings;
  mapping (string => address) public _contracts;
  string[] public _registry_names;
  mapping (string => address) public _registries;

  string private _name;
  Registry private registry;
  constructor(string memory name_, address registry_addr) {
    _name=name_;
    if (registry_addr > address(0)) { registry=Registry(registry_addr);}
  }
  function contracts (string memory attestation_string) public view returns (address){ return _contracts[attestation_string]; }
  function attestation_strings () public view returns (string[] memory){ return _attestation_strings; }
  function registries (string memory registry_name) public view returns (address){ return _registries[registry_name]; }
  function registry_names () public view returns (string[] memory){ return _registry_names; }
  
}
