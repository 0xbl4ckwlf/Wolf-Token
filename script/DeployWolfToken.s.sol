// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {WolfToken} from "../src/WolfToken.sol";

contract DeployWolfToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (WolfToken) {
        vm.startBroadcast();
        WolfToken wt = new WolfToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return wt;
    }
}
