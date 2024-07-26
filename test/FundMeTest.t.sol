// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Test,console} from "forge-std/Test.sol";
// import {} from "forge-std/.sol";
import {FundMe} from "../src/FundMe.sol";
contract FundMeTest is Test{
    FundMe fundme;
    function setUp() external{
        fundme = new FundMe();
    }
    function testMinimumUSDIsFive() public view {
        assertEq(fundme.MINIMUM_USD(),5e18);
    }
    function testOwnerIsMsgSender() public {
        assertEq(fundme.i_owner(),address(this));
    }
}