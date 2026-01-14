// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployWolfToken} from "../script/DeployWolfToken.s.sol";
import {WolfToken} from "../src/WolfToken.sol";

contract WolfTokenTest is Test {
    WolfToken public wolfToken;
    DeployWolfToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployWolfToken();
        wolfToken = deployer.run();

        // Wrap this transfer in a boolean check or use an assert
        vm.prank(msg.sender);
        bool success = wolfToken.transfer(bob, STARTING_BALANCE);
        require(success, "Transfer to Bob failed");
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, wolfToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend on his behalf
        vm.prank(bob);
        wolfToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        // check for the return value of transferFrom
        bool success = wolfToken.transferFrom(bob, alice, transferAmount);
        assertTrue(success);

        assertEq(wolfToken.balanceOf(alice), transferAmount);
        assertEq(wolfToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testInitialSupply() public view {
        uint256 expectedSupply = 1000 ether;
        assertEq(wolfToken.totalSupply(), expectedSupply);
    }

    function testTokenMetadata() public view {
        // verify token name
        string memory expectedName = "WOLF";
        assertEq(wolfToken.name(), expectedName);

        // verify token symbol
        string memory expectedSymbol = "WT";
        assertEq(wolfToken.symbol(), expectedSymbol);

        //verify token decimals, usully 18 for ERC20 tokens
        uint8 expectedDecimals = 18;
        assertEq(wolfToken.decimals(), expectedDecimals);
    }

    function testTransferMoreThanBalanceReverts() public {
        uint256 amountToTransfer = STARTING_BALANCE + 1;

        vm.prank(bob);
        // expect the transfer to revert due to insufficient balance
        //ince we're using OpenZeppelin's ERC20, the revert message is "ERC20: transfer amount exceeds balance"
        vm.expectRevert();
        wolfToken.transfer(alice, amountToTransfer);
    }

    // Bob approves 500 for Alice but she tries to spend 600
    function testTransferFromMoreThanAllowanceReverts() public {
        uint256 allowanceAmount = 500;
        uint256 spendAmount = 600;

        vm.prank(bob);
        wolfToken.approve(alice, allowanceAmount);

        vm.prank(alice);
        vm.expectRevert();
        wolfToken.transferFrom(bob, alice, spendAmount);
    }

    // Alice tries to transfer money without approval
    function testTransferFromWithoutApprovalReverts() public {
        uint256 amount = 100;

        vm.prank(alice);
        vm.expectRevert();
        wolfToken.transferFrom(bob, alice, amount);
    }

    // Zero amount transfer test
    // ERC20 standard allows zero amount transfer and ensures that they be treated as valid transfers
    function testTransferZeroAmount() public {
        uint256 amount = 0;
        address receiver = alice;

        vm.prank(bob);
        bool success = wolfToken.transfer(receiver, amount);

        assertTrue(success);
        assertEq(wolfToken.balanceOf(bob), STARTING_BALANCE);
        assertEq(wolfToken.balanceOf(alice), 0);
    }

    // Initiating a self transfer
    function testSelfTransfer() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        bool success = wolfToken.transfer(bob, amount);

        assertTrue(success);
        assertEq(wolfToken.balanceOf(bob), STARTING_BALANCE);
    }

    // Transfer to address(0) should revert
    // Erc20 standard disallow transfer to address(0) to prevent token loss
    function testTransferToZeroAddressReverts() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        vm.expectRevert();
        // OpenZeppelin ERC20 reverts with "ERC20: transfer to the zero address"
        // or ERC20InvalidReciver(address(0))
        wolfToken.transfer(address(0), amount);
    }
}
