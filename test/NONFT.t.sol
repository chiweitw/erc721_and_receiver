// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {NONFT} from "../src/NONFT.sol";
import {NFTReceiver} from "../src/NFTReceiver.sol";

contract NONFTTest is Test {
    uint256 tokenId = 123;
    NONFT public nft;
    NONFT public wrongNft;
    NFTReceiver public receiver;
    address public sender;
   
    function setUp() public {
        nft = new NONFT();
        wrongNft = new NONFT();
        receiver = new NFTReceiver(address(nft));
        sender = makeAddr("Alice");

    }

    // test mint - should mint a new token
    function testMint() public {
        nft.mint(sender, tokenId);
        assertEq(nft.ownerOf(tokenId), sender);
    }

    // test safeTransFrom - correct receiver get the nft
    function testSafeTransferFromToCorrectReceiver() public {
        vm.startPrank(sender);
        nft.mint(sender, tokenId);
        nft.approve(address(receiver), tokenId);
       
        nft.safeTransferFrom(sender, address(receiver), tokenId);
        assertEq(nft.balanceOf(address(receiver)), 1);
        vm.stopPrank();
    }

    // test safeTransFrom - transfer back when transfer wrong token
    function testSafeTransferFromToWrongReceiverTransferBack() public {
        vm.startPrank(sender);
        wrongNft.mint(sender, tokenId);
        wrongNft.safeTransferFrom(sender, address(receiver), tokenId);
        assertEq(wrongNft.ownerOf(tokenId), sender);
        vm.stopPrank();
    }

    // test safeTransFrom - mint NONFT to original owner when transfer wrong token
    function testSafeTransferFromToWrongReceiverMintToken() public {
        vm.startPrank(sender);
        wrongNft.mint(sender, tokenId);
        wrongNft.safeTransferFrom(sender, address(receiver), tokenId);
        assertEq(nft.balanceOf(address(sender)), 1);
        vm.stopPrank();
    }
}