// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Common.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";


contract Registry is Initializable {
  reg[] public _registries;
  reg[] public _attestations;

  string public name;

  function init (string memory name_) public initializer returns (Registry) {
    name=name_;
    return this;
  }

  function attestations () public view returns (reg[] memory){ return _attestations; }
  function registries () public view returns (reg[] memory){ return _registries; }

  function register_in_parent(Registry parent) public {
    parent.register_registry(this);
  }


  function register_registry(Registry child) public {
    require (Utils.find_in_reg_array(_registries, child.name()) == -1, "A registry by that name already exists in this registry");
    _registries.push(reg({name:child.name(),addy:address(child)}));
  }
  //using attestation string as unique here; eliminates the need for a registration function for each attestation class.
  function register_attestation(string memory attestation, address child) public {
    require (Utils.find_in_reg_array(_attestations,attestation) == -1, "An identical attestation already exists in this registry");
    _registries.push(reg({name:attestation,addy:child}));
  }
}
