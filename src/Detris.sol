// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Detris is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    uint256 public maxSupply;
    string private _baseTokenURI;
    Counters.Counter private supply;

    constructor(string memory baseTokenURI) ERC721("Detris", "DTS") {
        _baseTokenURI = baseTokenURI;
        maxSupply = 99;
    }

    function safeMint(address to) public {
        uint256 current = supply.current();
        require(current < maxSupply);
        supply.increment();
        _safeMint(to, current);
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

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setbaseURI(string memory baseTokenURI)
        external
        returns (string memory)
    {
        return _baseTokenURI = baseTokenURI;
    }
}
