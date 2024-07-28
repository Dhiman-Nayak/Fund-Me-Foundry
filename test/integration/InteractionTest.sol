// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract InteractionTest is Test {
    address USER = makeAddr("user");
    FundMe fundme;
    address deploymentAddress;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundme,) = deployFundMe.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // uint256 preUserBalance = address(USER).balance;
        // uint256 preOwnerBalance = address(fundme.getOwner()).balance;

        // // Using vm.prank to simulate funding from the USER address
        // vm.prank(USER);
        // fundme.fund{value: Send_Value}();

        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));

        assert((address(fundme).balance == 0));
        // uint256 afterUserBalance = address(USER).balance;
        // uint256 afterOwnerBalance = address(fundMe.getOwner()).balance;

        // assert(address(fundMe).balance == 0);
        // assertEq(afterUserBalance + SEND_VALUE, preUserBalance);
        // assertEq(preOwnerBalance + SEND_VALUE, afterOwnerBalance);
    }
}
