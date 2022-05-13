// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

struct reg {
  string name;
  address addy;
}

struct kv {
  string key;
  string value;
}

library Utils {
    
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }

  function find_in_reg_array(reg[] memory regs, string memory name) internal pure returns (int) {
    for (uint i=0;i < regs.length; i++) {
      if ( compareStrings(regs[i].name, name)) {
        return int(i);
      }
    }
    return -1;
  }
  function get_address_from_string(reg[] memory regs, string memory key) public pure returns (address) {
    int i=find_in_reg_array(regs, key);
    if (i > -1) {
        return regs[uint(i)].addy;
    } else {
        return address(0);
    }
  }
}