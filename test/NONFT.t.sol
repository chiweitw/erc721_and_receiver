// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {NONFT} from "../src/NONFT.sol";

contract NONFTTest is Test {
    NONFT public nft;
    address public receiver;
   
    function setUp() public {
        receiver = makeAddr("Receiver");
    }

    function testMint() public {
        uint256 tokenId = 1;
        // it should mint a new token
        nft.mint(receiver, tokenId);

        assertEq(nft.ownerOf(tokenId), receiver);
    }
}