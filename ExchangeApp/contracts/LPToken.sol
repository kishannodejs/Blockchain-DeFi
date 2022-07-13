//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/Ownable.sol";
import "../ERC20/ERC20.sol";

contract LPT is ERC20, Ownable{

    constructor(address _lpAddress) ERC20("Liquidity Pool Token", "LPT") {
        transferOwnership(_lpAddress);
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

}