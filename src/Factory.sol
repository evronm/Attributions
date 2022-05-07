// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Registry.sol';
import './Attestations.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory is Initializable {
  string[] public _registries_names;
  mapping (string => address) public _registries;
  address private base_registry;
  address private base_free_form;
  address private base_attendance;
  function init() public initializer returns (Factory) {
    base_registry=address(new Registry().init(""));
    base_free_form=address(new FreeForm().init(""));
    base_attendance=address(new Attendance().init("","",""));
    return this;
  }
  function create_registry(string memory child_name, address parent) public returns (Registry) {
    Registry child=Registry(Clones.clone(base_registry)).init(child_name);
    if (parent > address(0)) {
      Registry(parent).register_registry(child);
    } else {
      _registries_names.push(child.name());
      _registries[child.name()]=address(child);
    }
    return child;
  }

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
  function registries (string memory child_name) public view returns (address){ return _registries[child_name]; }
  function registries_names () public view returns (string[] memory){ return _registries_names; }
}
