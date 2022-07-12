//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NeoToken.sol";

/// @title Defi contract where user Lend and Borrow ETH in exchange to NeoToken

contract DeFi is NeoToken {
    //DeFi Owner
    address owner;

    constructor(string memory _name, string memory _symbol)
        NeoToken(_name, _symbol)
    {
        owner = msg.sender;
    }

    modifier miniLendETH() {
        require(
            msg.value >= 1 * 10**18,
            "Minimum lend amount should be 1 ether"
        );
        _;
    }

    modifier miniToken(uint256 _tokenAmnt) {
        require(
            balanceOf(msg.sender) >= _tokenAmnt,
            "Token amount less than 100"
        );
        require(
            _tokenAmnt % 100 == 0,
            "Token must be in multiple of 100"
        );
        _;
    }

/// @notice User can lend their ETH in Exchange of NeoToken - 1 ETH == 100 NeoToken
/// @dev user have to lend minimum 1 ETH

    function lendETH() public payable miniLendETH {
        uint256 NeoAmnt = msg.value / 10**16;
        mint(NeoAmnt);
    }

/// @notice User can borrow their ETH in Exchange of NeoToken.
/// @dev user have to borrow ETH in the multiple of 100 NeoToken

    function borrowETH(uint256 _tokenAmnt) public miniToken(_tokenAmnt) {
        transfer(address(this), _tokenAmnt);
        uint256 EthValue = _tokenAmnt * 10**16;
        payable(msg.sender).transfer(EthValue);
    }

/// @notice User can get the balance of DeFi contract ETH balance.

    function getBal() public view returns (uint256) {
        return address(this).balance;
    }
}
