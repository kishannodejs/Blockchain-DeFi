//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./LPToken.sol";
import "./NeoToken.sol";
import "../ERC20/Ownable.sol";
import "../ERC20/Math.sol";

contract LiquidityPool is Ownable {
    /***
     *@notice Eimt when a user add liquidity to the pool
     *@param _account address of the liquidity provider
     */
    event LiquidityAdded(address indexed _account);

    /***
     *@notice Eimt when a liquidity provider remove liquidity from the pool
     *@param _account address of the liquidity provider
     */
    event LiquidityRemoved(address indexed _account);

    /***
     *@notice Eimt when some trade either ETH to Neo Token or Neo Token to ETH
     *@param _account address of the trader
     *@param _ethTraded amount of ETH in trade
     *@param _neoTraded amount of Neo Token in trade
     */
    event TokensTrade(
        address indexed _account,
        uint256 _ethTraded,
        uint256 _neoTraded
    );

    //instance of LPToken contract 
    LPT lpToken;
    //instance of Neo Token contract
    NeoToken neoToken;
    //ETH Reserve of the liquidity pool
    uint256 ethReserve;
    //Neo Token Reserve of liquidity pool
    uint256 neoReserve;

    /***
     *@notice set the LPToken contract address to liquidity pool
     *
     *@dev developer needs to pass address of LPToken contract
     *
     *@param _neoToken address of the LPToken contract
     *
     *Requirements
     *
     * only owner able to call and set the address of  LPToken contract
     * address should be set only once after deploying contract
     */
    function setLPTAddress(LPT _lpToken) external onlyOwner {
        require(address(lpToken) == address(0), "WRITE_ONCE");
        lpToken = _lpToken;
    }

    /***
     *@notice set the Neo Token contract address to liquidity pool
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
     *@notice to get the ETH and Neo Token Reserve of Liquidity Pool
     */
    function getReserves() external view returns (uint256, uint256) {
        return (ethReserve, neoReserve);
    }

    /***
     *@notice to swap your ETH to NeoToken or NeoToken to ETH
     *
     *@param _account address of person who want ot swap token
     *@param _neoAmnt neo token user want to swap
     *
     */
    function swap(address _account, uint256 _neoAmnt) external payable {
        uint256 product = ethReserve * neoReserve;
        uint256 amountToTransfer;

        if (msg.value == 0) {
            uint256 currentNeoBalance = neoToken.balanceOf(address(this));
            uint256 addedBalance = neoReserve + _neoAmnt;

            require(addedBalance == currentNeoBalance, "Did_Not_Transfer");

            uint256 x = product / (currentNeoBalance);
            amountToTransfer = ethReserve - x;

            (bool sucess, ) = _account.call{value: amountToTransfer}("");
            require(sucess, "Transfer_Failed");
        } else {
            uint256 y = product / (ethReserve + msg.value);
            amountToTransfer = neoReserve - y;

            neoToken.transfer(_account, amountToTransfer);
        }
        emit TokensTrade(_account, msg.value, _neoAmnt);
        _update();
    }

    /***
     *@notice to deposit the liquidity to the liquiditypool
     *
     *@param _neoAmnt neo token provided by msg.sender for liquidity
     *@param _account address of liquidity provider
     *
     *Requirements
     *
     *msg.sender must have  neoToken for liquiditypool
     *msg.sender must haev ETH for liquiditypool
     *
     */
    function deposit(uint256 _neoAmnt, address _account) external payable {
        uint256 liquidity;
        uint256 totaSupply = lpToken.balanceOf(_account);
        uint256 ethAmnt = msg.value;

        if (totaSupply > 0) {
            liquidity = Math.min(
                (ethAmnt * totaSupply) / ethReserve,
                (_neoAmnt * totaSupply) / neoReserve
            );
        } else {
            liquidity = Math.sqrt(ethAmnt * _neoAmnt);
        }
        lpToken.mint(_account, liquidity);
        emit LiquidityAdded(_account);
        _update();
    }

    /***
     *@notice to withdraw the liquidity from the liquiditypool
     *
     *@param _account address of liquidity provider
     *
     *Requirements
     *
     *msg.sender must have LPToken
     *
     */
    function withdraw(address _account) external {
        uint256 liquidity = lpToken.balanceOf(_account);
        require(liquidity != 0, "NO_AVAILABLE_TOKENS");

        uint256 totalSupply = lpToken.totalSupply();

        uint256 ethAmnt = (ethReserve * liquidity) / totalSupply;
        uint256 neoAmnt = (neoReserve * liquidity) / totalSupply;

        lpToken.burn(_account, liquidity);
        (bool ethTransferSuccess, ) = _account.call{value: ethAmnt}("");
        bool neoTransferSuccess = neoToken.transfer(_account, neoAmnt);

        require(ethTransferSuccess && neoTransferSuccess, "FAILED_TRANSFER");
        emit LiquidityRemoved(_account);
        _update();
    }

    /***
     *@notice to update the ethReserve and neoReserve
     */
    function _update() private {
        ethReserve = address(this).balance;
        neoReserve = neoToken.balanceOf(address(this));
    }
}
