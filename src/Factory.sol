// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Attestations.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";


contract Factory is Initializable {
  tag[] public _tags;
  mapping (string => address) public attestation_names;
  address private base_attestation;
  function init() public initializer returns (Factory) {
    base_attestation=address(new Attestation());
    return this;
  }
  function create_tag(string memory new_tag) public {
    require (Tags.get_tag_index(_tags, new_tag) == -1, "Tag already exists");
    string[] memory foo;
    _tags.push(tag(new_tag,foo));
  }

  function create_attestation(kv[] calldata props, string[] calldata tags_) public returns (Attestation) {
    require (attestation_names[Kvs.get_value_from_key(props,"Name")] == address(0), "An Attestaion with this name already exists");
    Attestation al=Attestation(Clones.clone(base_attestation)).init(props,tags_);
    for (uint i=0; i < tags_.length; i++) {
      if (Tags.get_tag_index(_tags, tags_[i]) > -1) {
        _tags[i].names.push(Kvs.get_value_from_key(al.props(),"Name"));
      } else {
        create_tag(tags_[i]);
        _tags[_tags.length -1].names.push(Kvs.get_value_from_key(al.props(),"Name"));
      }
    }
    return al;
  }

  function tags() public view returns (tag[] memory) {return _tags;}
}
