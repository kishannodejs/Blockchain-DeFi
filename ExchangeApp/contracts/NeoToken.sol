//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/ERC20.sol";

contract NeoToken is ERC20 {
    address public DexRouter;
    address owner;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        owner = msg.sender;
        _mint(msg.sender, 100000);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    modifier onlyRouter() {
        require(msg.sender == DexRouter, "Not Router");
        _;
    }

    function setRouter(address _DexRouter) public onlyOwner {
        require(DexRouter == address(0), "Write Once");
        DexRouter = _DexRouter;
    }

    function incraseRouterAllownace(
        address _owner,
        address _spender,
        uint256 _amount
    ) public onlyRouter returns (bool) {
        _approve(
            _owner,
            _spender,
            allowance(msg.sender, address(this)) + _amount
        );

        return true;
    }
}
