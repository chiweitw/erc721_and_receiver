// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {console2} from "forge-std/Test.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./NONFT.sol";

contract NFTReceiver is IERC721Receiver {
    NONFT private nft;
    address private owner;

    constructor(address _nftAddress) {
        nft = NONFT(_nftAddress);
        owner = msg.sender;
    }

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes memory _data
    ) external override returns (bytes4) {
        // check if the sender is the ERC721 contract
        require(msg.sender == address(nft), "wrong receiver");

        return IERC721Receiver.onERC721Received.selector;
    }
}
