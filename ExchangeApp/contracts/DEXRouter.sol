//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NeoToken.sol";
import "./LiquidityPool.sol";
import "../ERC20/Ownable.sol";

contract DEXRouter is Ownable {
    NeoToken neoToken;
    LiquidityPool liquidityPool;
    
    function setLiquidityPoolAddress(LiquidityPool _liquidityPool) external onlyOwner {
        require(address(liquidityPool) == address(0), "WRITE_ONCE");
        liquidityPool = _liquidityPool;
    }

    function setNeoTokenAddress(NeoToken _neoToken) external onlyOwner {
        require(address(neoToken) == address(0), "WRITE_ONCE");
        neoToken = _neoToken;
    }
    
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

    function pullLiquidity() external {
        liquidityPool.withdraw(msg.sender);
    }

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
