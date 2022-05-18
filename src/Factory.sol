// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import './Attestations.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";


contract Factory is Initializable {
  tag[] public _tags;
  using Tags for *;  // For some reason, I can use * but I can't use _tags.  Can't find a reason for this in the docs...
  using Kvs for *;
  mapping (string => address) public attestation_names;
  address private base_attestation;
  function init() public initializer returns (Factory) {
    base_attestation=address(new Attestation());
    return this;
  }
  function create_tag(string memory new_tag) public {
    require (_tags.get_tag_index(new_tag) == -1, "Tag already exists");
    string[] memory foo;
    _tags.push(tag(new_tag,foo));
  }

  function create_attestation(kv[] calldata props, string[] calldata tags_) public returns (Attestation) {
    string memory name=props.get_value_from_key("Name");
    require (! (attestation_names[name] > address(0)), "An Attestaion with this name already exists");
    Attestation al=Attestation(Clones.clone(base_attestation)).init(props,tags_);
    attestation_names[name]=address(al);

    for (uint i=0; i < tags_.length; i++) {
      if (_tags.get_tag_index(tags_[i]) > -1) {
        _tags[i].names.push(al.props().get_value_from_key("Name"));
      } else {
        create_tag(tags_[i]);
        _tags[_tags.length -1].names.push(al.props().get_value_from_key("Name"));
      }
    }
    return al;
  }

  function tags() public view returns (tag[] memory) {return _tags;}
}
