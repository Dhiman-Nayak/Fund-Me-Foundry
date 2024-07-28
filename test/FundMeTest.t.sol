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
uint256 public constant GAS_PRICE = 1;
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
        vm.expectRevert(); //expect next line should revert
        fundme.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.startPrank(USER);
        fundme.fund{value: 10e18}();
        vm.stopPrank();

        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
    }

    function testAddsFunderToArrayOfFunders() public funded{
        // vm.prank(USER);
        // fundme.fund{value:10e18}();
        address funder = fundme.getFunder(0);
        assertEq(funder,USER);
    }

    modifier funded()  {
        vm.prank(USER);
        fundme.fund{value:10e18}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded{
        // vm.prank(USER);
        // fundme.fund{value:10e18}();

        vm.expectRevert();
        // vm.prank(USER);
        fundme.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded{
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundedBalance = address(fundme).balance;

        uint gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        uint gasEnd = gasleft();
        console.log(gasStart-gasEnd);

        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundedBalance = address(fundme).balance;
        assertEq(endingFundedBalance,0);
        assertEq(startingOwnerBalance+startingFundedBalance,endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders=10;
        uint160 startingFundIndex=1;
        for (uint160 i = startingFundIndex; i < numberOfFunders; i++) {
            hoax(address(i),10e18);
            fundme.fund{value:10e18}();
        }

        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundedBalance = address(fundme).balance;

        vm.prank(fundme.getOwner());
        fundme.withdraw();

        assert(address(fundme).balance==0);
        assert(startingFundedBalance+startingOwnerBalance==fundme.getOwner().balance);
    }
    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunders=10;
        uint160 startingFundIndex=1;
        for (uint160 i = startingFundIndex; i < numberOfFunders; i++) {
            hoax(address(i),10e18);
            fundme.fund{value:10e18}();
        }

        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundedBalance = address(fundme).balance;

        vm.prank(fundme.getOwner());
        fundme.cheaperWithdraw();

        assert(address(fundme).balance==0);
        assert(startingFundedBalance+startingOwnerBalance==fundme.getOwner().balance);
    }

}
