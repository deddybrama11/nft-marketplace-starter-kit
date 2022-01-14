// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
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


    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zeros

    function balanceOf(address _owner) public view returns(uint256)
    {
        require(_owner != address(0),'owner query for non-existent token');
        return _OwnedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent to address');
        return owner;
    }

     function _exists(uint256 tokenId) internal view returns(bool){
         // setting the address of nft owner to check the mapping
         // of the address from tokenOwner at the tokenId
         address owner = _tokenOwner[tokenId];
         // return truthiness the address is not zero
         return owner != address(0);
     }

     function _mint(address to, uint256 tokenId) internal virtual{
         // requires that the address isn't  zero
         require(to != address(0), 'ERC721: minting to the zero address');
         // requires that the token does not already exist
         require(!_exists(tokenId), 'ERC721: token already minted');
         // we are adding a new address with a token id for minting
         _tokenOwner[tokenId] = to;
         // keeping track of each address that is minting and adding one to the count
         _OwnedTokensCount[to] += 1;

         emit Transfer(address(0), to, tokenId);
     }
}