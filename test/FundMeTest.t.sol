// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
// import {} from "forge-std/.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    address USER = makeAddr("user");
    FundMe fundme;
    address deploymentAddress;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundme, ) = deployFundMe.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testMinimumUSDIsFive() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundme.getVersion();
        // cosole.log(version);
        assertEq(version, 4);
    }

    function testFundFailWithoutEnoughEth() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.startPrank(USER);
        fundme.fund{value: 10e18}();
        vm.stopPrank();

        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);}
}
