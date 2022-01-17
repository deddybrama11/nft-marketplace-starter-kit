// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply(uint256)") ^
                    keccak256("tokenByIndex(uint256)") ^
                    keccak256("tokenOfOwnerByIndex(address,uint256)")
            )
        );
    }

    uint256[] private _allTokens;

    // CHALLANGE !
    // mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // two functions - one that returns tokenByIndex and
    // another one that returns tokenOfByOwnerIndex

    function tokenByIndex(uint256 _index)
        public
        view
        override
        returns (uint256)
    {
        // make sure that the index is not out of bounds of the
        // total supply
        require(totalSupply() > _index, "global index is out of bounds!");
        return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index)
        public
        view
        override
        returns (uint256)
    {
        require(_index < balanceOf(_owner), "owner index is out of bounds!");
        return _ownedTokens[_owner][_index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        // EXERCISE

        // 2. ownedTokensIndex tokenId set to address of ownedTokens position
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

        // 1. add address and tokenId to _ownedToken
        _ownedTokens[to].push(tokenId);
    }

    // add tokens to the _alltokens array and set the position of the tokens indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    // return the total supply of the _allTokens array
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
}
