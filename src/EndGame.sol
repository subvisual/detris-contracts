// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EndGame is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    error TokenURINotSet(uint256 tokenId);

    // Mapping for individual token URIs
    mapping(uint256 => string) internal _tokenURIs;

    Counters.Counter private supply;

    IERC721 gateway;

    constructor(address l2gateway) ERC721("DetrisEndGame", "DEG") {
        gateway = IERC721(l2gateway);
    }

    modifier onlyHolder() {
        require(gateway.balanceOf(msg.sender) > 0);
        _;
    }

    function safeMint(string memory uri) public onlyHolder {
        uint256 current = supply.current();
        supply.increment();
        _safeMint(msg.sender, current);
        _tokenURIs[current] = uri;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (bytes(_tokenURIs[tokenId]).length == 0) {
            revert TokenURINotSet(tokenId);
        }
        return _tokenURIs[tokenId];
    }
}
