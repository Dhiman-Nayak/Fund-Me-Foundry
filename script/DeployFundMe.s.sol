// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe,address) {

        HelperConfig helperConfig= new HelperConfig();

        vm.startBroadcast();
        FundMe fundme = new FundMe(helperConfig.activeNetworkConfig());
        vm.stopBroadcast();
        return (fundme,address(this));
    }
}
