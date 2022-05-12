// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

struct reg {
  string name;
  address addy;
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
}