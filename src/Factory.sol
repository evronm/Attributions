// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import 'Registry.sol';
import "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory {
  function create_registry(string memory child_name, address parent) public returns (Registry) {
    Registry child=new Registry(child_name);
    if (parent > address(0)) {
      Registry(parent).register_registry(child);
    
    }
    return child;
  }
}
