// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import { Base64 } from "./Base64.sol";
// ChainNFTModule#OnChainNFT - 0x6efA1fe9ce26E9cC0FF850Cb3805D0D032369D88
contract OnChainNFT is ERC721URIStorage, Ownable {
    event Minted(uint256 tokenId);

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Constructor now calls Ownable with msg.sender as initial owner
    constructor() ERC721("ChainNFT", "CNF") Ownable(msg.sender) {}

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(svg));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function formatTokenURI(string memory imageURI) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "LCM ON-CHAINED", "description": "A simple SVG based on-chain NFT", "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function mint(string memory svg) public onlyOwner {
        string memory imageURI = svgToImageURI(svg);
        string memory tokenURI = formatTokenURI(imageURI);

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        emit Minted(newItemId);
    }
}
