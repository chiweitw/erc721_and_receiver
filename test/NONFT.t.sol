// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {NONFT} from "../src/NONFT.sol";
import {NFTReceiver} from "../src/NFTReceiver.sol";

contract NONFTTest is Test {
    NONFT public nft;
    NFTReceiver public receiver;
    address wrongNFTAddress;
    NFTReceiver public wrongReceiver;
    address public sender;
   
    function setUp() public {
        nft = new NONFT();
        receiver = new NFTReceiver(address(nft));
        wrongNFTAddress = makeAddr("wrongNFTAddress");
        wrongReceiver = new NFTReceiver(wrongNFTAddress);
        sender = makeAddr("Alice");
    }

    // it should mint a new token
    function testMint() public {
        uint256 tokenId = 123;
        nft.mint(address(receiver), tokenId);
        assertEq(nft.ownerOf(tokenId), address(receiver));
    }

    // it should transfer successfully with correct receiver
    function testSafeTransferFromToCorrectReceiver() public {
        uint256 tokenId = 123;
        vm.startPrank(sender);
        nft.mint(sender, tokenId); 
        nft.approve(address(receiver), tokenId);
       
        nft.safeTransferFrom(sender, address(receiver), tokenId);
        assertEq(nft.balanceOf(address(receiver)), 1);
        vm.stopPrank();
    }

    // it should revert if not the correct receiver
    function testSafeTransferFromToWrongReceiver() public {
        uint256 tokenId = 123;
        vm.startPrank(sender);
        nft.mint(sender, tokenId); 
        nft.approve(address(receiver), tokenId);
       
        // it should revert if not the correct receiver
        vm.expectRevert("wrong receiver");
        nft.safeTransferFrom(sender, address(wrongReceiver), tokenId);

        // The Nft qty owner and Sender should remain if transfer to wrong correct receiver
        assertEq(nft.balanceOf(address(sender)), 1);
        assertEq(nft.balanceOf(address(receiver)), 0);

        vm.stopPrank();
    }
}