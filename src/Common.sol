// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

struct str_addr {
  string name;
  address addy;
}

struct kv {
  string key;
  string value;
}
struct tag {
  string tag;
  address[] addresses;
}

library Utils {
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }
}

library Str_addrs {

  function find_in_str_addr_array(str_addr[] memory str_addrs, string memory name) internal pure returns (int) {
    for (uint i=0;i < str_addrs.length; i++) {
      if ( Utils.compareStrings(str_addrs[i].name, name)) {
        return int(i);
      }
    }
    return -1;
  }
  function get_address_from_string(str_addr[] memory str_addrs, string memory key) public pure returns (address) {
    int i=find_in_str_addr_array(str_addrs, key);
    if (i > -1) {
        return str_addrs[uint(i)].addy;
    } else {
        return address(0);
    }
  }
}

library Kvs {
  function get_index_from_key(kv[] memory kvs, string memory key) internal pure returns (int) {
    for (uint i=0;i < kvs.length; i++) {
      if ( Utils.compareStrings(kvs[i].key, key)) {
        return int(i);
      }
    }
    return -1;
  }
  function get_value_from_key(kv[] memory kvs, string memory key) public pure returns (string memory) {
    int i=get_index_from_key(kvs, key);
    require(i > -1);
    return kvs[uint(i)].value;
  }

}

library Tags {
  function get_tag_index(tag[] memory tags, string memory key) public pure returns (int) {
    for (uint i=0;i < tags.length; i++) {
      if ( Utils.compareStrings(tags[i].tag, key)) {
        return int(i);
      }
    }
    return -1;

  }
  function get_addresses(tag[] memory tags, string memory key) public pure returns (address[] memory) {
    int i=get_tag_index(tags, key);
    require(i > -1);
    return tags[uint(i)].addresses;
  }
}