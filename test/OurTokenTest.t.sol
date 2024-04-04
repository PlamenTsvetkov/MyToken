// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob;
    address alice;

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        
        bob = makeAddr("bob");
        alice = makeAddr("alice");

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        //Bob approves alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice,initialAllowance);

        uint256 transferAmout = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmout);

        assertEq(ourToken.balanceOf(alice), transferAmout);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE-transferAmout);

    }
}
