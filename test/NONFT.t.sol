// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {NONFT} from "../src/NONFT.sol";
import {NFTReceiver} from "../src/NFTReceiver.sol";

contract NONFTTest is Test {
    NONFT public nft;
    NFTReceiver public receiver;
   
    function setUp() public {
        nft = new NONFT();
        receiver = new NFTReceiver(address(nft));
    }

    // it should mint a new token
    function testMint() public {
        uint256 tokenId = 1;
        nft.mint(address(receiver), tokenId);
        assertEq(nft.ownerOf(tokenId), address(receiver));
    }
}