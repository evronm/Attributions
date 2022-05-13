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
  //address private base_free_form;
  //address private base_attendance;
  function init() public initializer returns (Factory) {
    base_registry=address(new Registry().init(""));
   // base_free_form=address(new FreeForm().init(""));
   // base_attendance=address(new Attendance().init("","",""));
    return this;
  }
  function create_registry(string memory child_name, address parent) public returns (Registry) {
    Registry child=Registry(Clones.clone(base_registry)).init(child_name);
    if (parent > address(0)) {
      Registry(parent).register_registry(child);
    } else {
      require (Utils.find_in_reg_array(_registries, child_name) == -1, "A registry by that name already exists in this factory");
      _registries.push(reg({name:child.name(),addy:address(child)}));
    }
    return child;
  }

/*
  function create_free_form(string memory attestation, address registry) public returns (FreeForm) {
    FreeForm ff=FreeForm(Clones.clone(base_free_form)).init(attestation);
    if (registry > address(0)) {
      Registry(registry).register_attestation(attestation,address(ff));
    }
    return ff;
  }

  function create_attendance(string memory name, string memory location, string memory date, address registry) public returns (Attendance) {
    Attendance att=Attendance(Clones.clone(base_attendance)).init(name, location, date);
    if (registry > address(0)) {
      Registry(registry).register_attestation(att.attestation(),address(att));
    }
    return att;
  }
  */
  function registries () public view returns (reg[] memory){ return _registries; }
}
