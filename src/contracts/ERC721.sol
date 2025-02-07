// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

contract ERC721 is ERC165, IERC721 {
    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    //Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    // EXERCISE: 1. REGISTER THE INTERFACE FOR THE ERC721 contract so that it includes
    // the following functions: balanceOf, ownerOf,transferFrom
    // *note by register the interface: write the constructor with the according bytes convertion

    // 2. REGISTER THE INTERFACE FOR THE ERC721Enumerable contract
    //  totalSupply, tokenByIndex, tokenOfOwnerByIndex

    // 3. REGISTER THE INTERFACE FOR THE ERC721Metadata contract
    //  name and symbol function
    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "owner query for non-existent token");
        return _OwnedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "owner query for non-existent to address");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        // return truthiness the address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't  zero
        require(to != address(0), "ERC721: minting to the zero address");
        // requires that the token does not already exist
        require(!_exists(tokenId), "ERC721: token already minted");
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one to the count
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        // a. require that the address receiving a token is not a rezo address
        require(_to != address(0), "Error - ERC721 Transfer to zero address");
        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token the address does not own!"
        );

        // 2. update the balance of the address _from token
        _OwnedTokensCount[_from] -= 1;
        // 3. update the balance of the address _to
        _OwnedTokensCount[_to] += 1;
        // 1. add the token id to the address receiving the token
        _tokenOwner[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    // 1. require that the person approving is the owner
    // 2. we are approving an address to a token (tokenId)
    // 3. require that we cant approve sending tokens of the owner to the owner
    // 4. update the map of the approval addresses

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, "Error - approval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of the token"
        );
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(tokenId), "token does not exists");
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }
}
