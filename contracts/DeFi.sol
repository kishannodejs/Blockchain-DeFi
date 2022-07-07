//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeFi{
    address owner;
    constructor(){
        owner= msg.sender;
    }
}