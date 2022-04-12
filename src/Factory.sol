// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import 'Registry.sol';
import 'Attestations.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory is Initializable {
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
    
    }
    return child;
  }
}
