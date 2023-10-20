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

    // test mint - should mint a new token
    function testMint() public {
        uint256 tokenId = 123;
        nft.mint(sender, tokenId);
        assertEq(nft.ownerOf(tokenId), sender);
    }

    // test safeTransFrom - correct receiver get the nft
    function testSafeTransferFromToCorrectReceiver() public {
        uint256 tokenId = 123;
        vm.startPrank(sender);
        nft.mint(sender, tokenId); 
        nft.approve(address(receiver), tokenId);
       
        nft.safeTransferFrom(sender, address(receiver), tokenId);
        assertEq(nft.balanceOf(address(receiver)), 1);
        vm.stopPrank();
    }

    // test safeTransFrom - transfer back when transfer to wrong receiver
    function testSafeTransferFromToWrongReceiverTransferBack() public {
        uint256 tokenId = 123;
        vm.startPrank(sender);
        nft.mint(sender, tokenId); 
        nft.safeTransferFrom(sender, address(wrongReceiver), tokenId);
        assertEq(nft.ownerOf(tokenId), sender);
        vm.stopPrank();
    }

    // test safeTransFrom - mint new token to original owner when transfer to wrong receiver
    function testSafeTransferFromToWrongReceiverMintToken() public {
        uint256 tokenId = 123;
        vm.startPrank(sender);
        nft.mint(sender, tokenId); 
        nft.safeTransferFrom(sender, address(wrongReceiver), tokenId);
        assertEq(nft.ownerOf(tokenId+1), sender);
        vm.stopPrank();
    }
}