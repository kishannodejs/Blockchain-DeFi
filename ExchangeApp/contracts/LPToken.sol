//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/Ownable.sol";
import "../ERC20/ERC20.sol";

contract LPT is ERC20, Ownable {
    address lpAddress;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    function setLPAddress(address _lpAddress) external onlyOwner {
        require(lpAddress == address(0), "Write Once");
        lpAddress = _lpAddress;
        transferOwnership(_lpAddress);
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }
}
