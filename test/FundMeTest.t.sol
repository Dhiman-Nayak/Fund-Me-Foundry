// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Test,console} from "forge-std/Test.sol";
// import {} from "forge-std/.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundme;
    address deploymentAddress;
    function setUp() external{
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe= new DeployFundMe();
        (fundme,deploymentAddress)=deployFundMe.run();
    }
    function testMinimumUSDIsFive() public view {
        assertEq(fundme.MINIMUM_USD(),5e18);
    }
    function testOwnerIsMsgSender() public view {
        assertEq(fundme.getOwner(),msg.sender);
    }
    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundme.getVersion();
        // cosole.log(version);
        assertEq(version,4);
    }
}