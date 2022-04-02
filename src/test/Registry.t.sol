
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Attestations.t.sol";

contract RegistryTest is ExtendedDSTest {
  Registry registry;
  FreeForm freeform;
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function setUp() public {
    freeform = new FreeForm("freeformtest", address(0));
  }
}
