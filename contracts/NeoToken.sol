//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/ERC20.sol";

contract NeoToken is ERC20{

    address owner;
    uint AMM;
    uint LiquiToken;

    constructor(string memory _name, string memory _symbol, uint _supply) 
    ERC20(_name, _symbol){
        owner = msg.sender;
        _mint(msg.sender, _supply);
    }

}