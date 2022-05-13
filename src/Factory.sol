// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Registry.sol';
import './Attestations.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";


contract Factory is Initializable {
  // from Registry.sol
  reg[] public _registries;
  address private base_registry;
  address private base_attestation;
  function init() public initializer returns (Factory) {
    base_registry=address(new Registry().init(""));
    base_attestation=address(new AttestationList());
    return this;
  }
  function create_registry(string memory child_name, address parent) public returns (Registry) {
    Registry child=Registry(Clones.clone(base_registry)).init(child_name);
    if (parent > address(0)) {
      Registry(parent).register_registry(child);
    } else {
      require (Regs.find_in_reg_array(_registries, child_name) == -1, "A registry by that name already exists in this factory");
      _registries.push(reg({name:child.name(),addy:address(child)}));
    }
    return child;
  }

  function create_attestation(kv[] calldata props, address registry) public returns (AttestationList) {
    AttestationList al=AttestationList(Clones.clone(base_attestation)).init(props);
    if (registry > address(0)) {
      Registry(registry).register_attestation(props[uint(Kvs.get_index_from_key(props, "Name"))].value,address(al));
    }
    return al;
  }

  function registries () public view returns (reg[] memory){ return _registries; }
}
