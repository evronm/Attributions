// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import 'Registry.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory is Initializable {
  address private base_registry;
  Registry private _br;
  function init() public initializer returns (Factory) {
    _br=new Registry().init("");
    base_registry=address(_br);
    return this;
  }
  function br() public view returns (address){
    return address(_br);
  }
  function create_registry(string memory child_name, address parent) public returns (Registry) {
    Registry child=Registry(Clones.clone(base_registry)).init(child_name);
    if (parent > address(0)) {
      Registry(parent).register_registry(child);
    
    }
    return child;
  }
}
