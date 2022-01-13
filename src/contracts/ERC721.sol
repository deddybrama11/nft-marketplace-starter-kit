// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {
    /*
        BUILDING OUT THE MINTING FUNCTION :
        A. NFT TO POINT TO AN ADDRES
        B. KEEP TRACK OF THE TOKEN ID'S
        C. KEEP TRACK OF TOKEN OWNERS ADDRESSES TO TOKEN ID'S
        D. KEEP TRACK OF HOW MANY TOKENS AN OWNER ADDRESS HAS
        E. CREATE AN EVENT THAT EMITS A TRANSFER LOG - CONTRACT ADDRESS, WHERE IT IS BEING MINTED TO , THE ID
     */

    // Mapping from token id to the owner
     mapping(uint256=> address) private _tokenOwner;

     // Mapping from owner to number of owned tokens
     mapping(address => uint256) private _OwnedTokensCount;

     function _exists(uint256 tokenId) internal view returns(bool){
         // setting the address of nft owner to check the mapping
         // of the address from tokenOwner at the tokenId
         address owner = _tokenOwner[tokenId];
         // return truthiness the address is not zero
         return owner != address(0);
     }

     function _mint(address to, uint256 tokenId) internal {
         // requires that the address isn't  zero
         require(to != address(0), 'ERC721: minting to the zero address');
         // requires that the token does not already exist
         require(!_exists(tokenId), 'ERC721: token already minted');
         // we are adding a new address with a token id for minting
         _tokenOwner[tokenId] = to;
         // keeping track of each address that is minting and adding one to the count
         _OwnedTokensCount[to] += 1;


     }
}