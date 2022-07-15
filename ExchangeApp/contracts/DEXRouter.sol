//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NeoToken.sol";
import "./LiquidityPool.sol";
import "../ERC20/Ownable.sol";

contract DEXRouter is Ownable {
    //instance of Neo Token contract
    NeoToken public neoToken;
    //instance of LiquidityPool contract
    LiquidityPool public liquidityPool;

    /***
     *@notice set the Liquidity Pool contract address to Router
     *
     *@dev developer needs to pass address of Liquidity Pool  contract
     *
     *@param _liquidityPool address of the Liquidity Pool contract
     *
     *Requirements
     *
     * only owner able to call and set the address of Liquidity Pool contract
     * address should be set only once after deploying contract
     */
    function setLiquidityPoolAddress(LiquidityPool _liquidityPool)
        external
        onlyOwner
    {
        require(address(liquidityPool) == address(0), "WRITE_ONCE");
        liquidityPool = _liquidityPool;
    }

    /***
     *@notice set the Neo Token contract address to Router
     *
     *@dev developer needs to pass address of Neo Token contract
     *
     *@param _neoToken address of the Neo Token contract
     *
     *Requirements
     *
     * only owner able to call and set the address of  Neo Token contract
     * address should be set only once after deploying contract
     */
    function setNeoTokenAddress(NeoToken _neoToken) external onlyOwner {
        require(address(neoToken) == address(0), "WRITE_ONCE");
        neoToken = _neoToken;
    }

    /***
     *@notice to add the liquidity to the liquiditypool
     *
     *@param _neoAmnt neo token provided by msg.sender for liquidity
     *
     *Requirements
     *
     *msg.sender must have  neoToken for liquiditypool
     *msg.sender must have ETH for liquiditypool
     *
     */
    function addLiquidity(uint256 _neoAmnt) external payable {
        require(neoToken.balanceOf(msg.sender) > 0, "No_Available_Tokens");

        bool success = neoToken.incraseRouterAllownace(
            msg.sender,
            address(this),
            _neoAmnt
        );

        require(success);

        neoToken.transferFrom(msg.sender, address(liquidityPool), _neoAmnt);
        liquidityPool.deposit{value: msg.value}(_neoAmnt, msg.sender);
    }

    /***
     *@notice to withdraw the liquidity from the liquiditypool
     *
     *Requirements
     *
     *msg.sender must be a liquidity provider
     *
     */
    function pullLiquidity() external {
        liquidityPool.withdraw(msg.sender);
    }

    /***
     *@notice to swap you ETH to Neo Token or Neo Token to ETH
     *
     *@dev developer needs to pass Neo Token for Neo Token to ETH swap
     *      or pass ETH for ETH to Neo Token swap
     *
     *@param _neoAmnt amount of Neo Token to swap
     *
     */
    function swapToken(uint256 _neoAmnt) external payable {
        bool success = neoToken.incraseRouterAllownace(
            msg.sender,
            address(this),
            _neoAmnt
        );

        require(success);

        neoToken.transferFrom(msg.sender, address(liquidityPool), _neoAmnt);
        liquidityPool.swap{value: msg.value}(msg.sender, _neoAmnt);
    }
}
