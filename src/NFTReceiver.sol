// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
        address from,
        uint256 tokenId,
        bytes memory _data
    ) external override returns (bytes4) {
        // 1. check if the sender is the ERC721 contract
        // 2. if not, transfer this token back to the original owner
        // 3. and also mint the ERC721 token to the original owner

        if (msg.sender != address(nft)) {
            IERC721(msg.sender).transferFrom(address(this), from, tokenId);
            nft.mint(from, tokenId);
        }

        return IERC721Receiver.onERC721Received.selector;
    }
}
