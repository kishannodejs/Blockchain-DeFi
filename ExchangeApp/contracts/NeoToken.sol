//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/ERC20.sol";

/// @title Contract to deploy Neo Token

contract NeoToken is ERC20 {
    //address to store router for contract
    address public DexRouter;

    //owner of the Neo Token contract
    address owner;

    /***
     *@dev developer haev to provide token and symbol
     */
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        owner = msg.sender;
        _mint(msg.sender, 100000);
    }

    //to check msg.sender is owner or not
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    //to check msg.sender is router or not
    modifier onlyRouter() {
        require(msg.sender == DexRouter, "Not Router");
        _;
    }

    /***
     *@notice to set the contract address of router
     *
     *@dev developer needs to pass address of router
     *
     *@param _DexRouter address of the router
     *
     *Requirements
     *
     * only owner able to call and set the address of router
     * address should be set only once after deploying contract
     */
    function setRouter(address _DexRouter) public onlyOwner {
        require(DexRouter == address(0), "Write Once");
        DexRouter = _DexRouter;
    }

    /***
     *@notice to set the allowance to router from msg.sender
     *
     *@dev developer needs to pass address of router
     *
     *@param _owner address of the msg.sender
     *@param _spender address of the router
     *@param _amount amount that msg.sender need to allow to spend to router
     *
     *Requirements
     *
     * only router contract able to call
     *
     *@return bool success for confirmation
     */
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
