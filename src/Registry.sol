// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Common.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";


contract Registry is Initializable {
  str_addr[] public _registries;
  str_addr[] public _attestations;

  string public name;

  function init (string memory name_) public initializer returns (Registry) {
    name=name_;
    return this;
  }

  function attestations () public view returns (str_addr[] memory){ return _attestations; }
  function registries () public view returns (str_addr[] memory){ return _registries; }

  function register_in_parent(Registry parent) public {
    parent.register_registry(this);
  }

  function register_registry(Registry child) public {
    require (Str_addrs.find_in_str_addr_array(_registries, child.name()) == -1, "A registry by that name already exists in this registry");
    _registries.push(str_addr({name:child.name(),addy:address(child)}));
  }
  //using attestation name as unique here; Subject to change, I guess...
  function register_attestation(string memory attestation_name, address child) public {
    require (Str_addrs.find_in_str_addr_array(_attestations,attestation_name) == -1, "An identical attestation already exists in this registry");
    _attestations.push(str_addr({name:attestation_name,addy:child}));
  }
}
