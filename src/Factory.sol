// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Registry.sol';
import './Attestations.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";


contract Factory is Initializable {
  // from Registry.sol
  //str_addr[] public _registries;
  tag[] public _tags;
  address private base_registry;
  address private base_attestation;
  function init() public initializer returns (Factory) {
    base_registry=address(new Registry().init(""));
    base_attestation=address(new Attestation());
    return this;
  }
  function create_tag(string memory new_tag) public {
    require (Tags.get_tag_index(_tags, new_tag) == -1, "Tag already exists");
    address[] memory foo;
    _tags.push(tag(new_tag,foo));
  }
  /*
  function create_registry(string memory child_name, address parent) public returns (Registry) {
    Registry child=Registry(Clones.clone(base_registry)).init(child_name);
    if (parent > address(0)) {
      Registry(parent).register_registry(child);
    } else {
      require (Str_addrs.find_in_str_addr_array(_registries, child_name) == -1, "A registry by that name already exists in this factory");
      _registries.push(str_addr({name:child.name(),addy:address(child)}));
    }
    return child;
  } */

  function create_attestation(kv[] calldata props, string[] calldata tags_) public returns (Attestation) {
    Attestation al=Attestation(Clones.clone(base_attestation)).init(props,tags_);
    for (uint i=0; i < tags_.length; i++) {
      if (Tags.get_tag_index(_tags, tags_[i]) > -1) {
        _tags[i].addresses.push(address(al));
      } else {
        create_tag(tags_[i]);
        _tags[_tags.length -1].addresses.push(address(al));
      }
    }
    return al;
  }

  function tags() public view returns (tag[] memory) {return _tags;}
  //function registries () public view returns (str_addr[] memory){ return _registries; }
}
