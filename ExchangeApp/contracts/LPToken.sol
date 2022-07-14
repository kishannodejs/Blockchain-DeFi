//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/Ownable.sol";
import "../ERC20/ERC20.sol";

contract LPT is ERC20, Ownable {
    //address of liquidity pool
    address lpAddress;

    /***
     *@dev developer haev to provide token and symbol
     */
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    /***
     *@notice to transfer the ownership of LPToken contract to liquidity pool
     *
     *@dev developer needs to pass address of liquidity pool
     *
     *@param _lpAddress address of the liquidity pool
     *
     *Requirements
     *
     * only owner able to call and transfer ownership to liquidity pool
     *
     */
    function setLPAddress(address _lpAddress) external onlyOwner {
        require(lpAddress == address(0), "Write Once");
        lpAddress = _lpAddress;
        transferOwnership(_lpAddress);
    }

    /***
     *@notice to mint the LPToken for liquidity provider
     *
     *@param account address of liquidity provider
     *@param amount of LPToken to mint for liquidity pool
     *
     *Requirements
     *
     * only owner(liquidity pool) able to call and mint LPToken for liquidity provider
     */
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    /***
     *@notice to burn the LPToken for liquidity provider
     *
     *@param account address of liquidity provider
     *@param amount of LPToken to burn for liquidity pool
     *
     *Requirements
     *
     * only owner(liquidity pool) able to call and burn LPToken for liquidity provider
     */
    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }
}
