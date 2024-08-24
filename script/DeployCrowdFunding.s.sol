// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract CrowdFundingDeployScript is Script{
    function run() external {
        vm.startBroadcast();

        CrowdFunding crowdFunding = new CrowdFunding();
        vm.stopBroadcast();
    }
}