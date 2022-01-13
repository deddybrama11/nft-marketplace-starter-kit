// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Kryptobird {
    
    string public name;
    string private symbol;

    constructor() {
        name = "Kryptobird";
        symbol = "KBIRDZ";
    }
}
