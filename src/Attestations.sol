// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

abstract contract AttestationList {
  string private _attestation;
  mapping (address => address[]) public attestations_by;
  mapping (address => address[]) public attestations_about;

  function attest(address about_addr) public {
    require (find_redundant(about_addr) == false, "Attestation already exists.");
    attestations_by[msg.sender].push(about_addr);
    attestations_about[about_addr].push(msg.sender);
  }

  function find_redundant (address about_addr) internal view returns (bool){
      address[] memory attestations_by_sender=attestations_by[msg.sender];
      for (uint i=0; i < attestations_by_sender.length; i++) {
          if (attestations_by_sender[i] == about_addr) {
              return true;
          }
      }
      return false;
  }

  function attestation () public view virtual returns (string memory) {
    return  _attestation;
}
}
contract FreeForm is AttestationList { 
  string private _attestation;
  constructor(string memory attestation_) {
    _attestation=attestation_;
  }
  function attestation () public view override returns (string memory) {
    return  _attestation;
  }
}

contract Attendance is AttestationList {
    struct event_details {
        string name;
        string place;
        string date;
    }
    event_details private _attestation;
    constructor (event_details memory attestation_) {
        _attestation=attestation_;
    }

    function attestation () public view override returns (string memory) {
        return  string(string.concat("name: ", bytes(_attestation.name), "\n", "place: ", bytes(_attestation.place),"\n", "date:", bytes(_attestation.date)));
    }
}
