// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // array to store our nfts
    string [] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBirdz) public
    {
        require(!_kryptoBirdzExists[_kryptoBirdz], 'Error - kryptoBird already exists');
        // this is deprecated uint _id = KryptoBirdz.push(_kryptoBirdz);
        kryptoBirdz.push(_kryptoBirdz);
        uint _id = kryptoBirdz.length -1;
        _mint(msg.sender, _id);
        _kryptoBirdzExists[_kryptoBirdz] = true;
    }

    constructor() ERC721Connector('KryptoBird','KBIRDZ') {

    }
}
