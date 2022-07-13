//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./LPToken.sol";
import "./NeoToken.sol";
import "../ERC20/Ownable.sol";
import "../ERC20/Math.sol";

contract LiquidityPool is Ownable {
    event LiquidityAdded(address indexed _account);
    event LiquidityRemoved(address indexed _account);
    event TokensTrade(
        address indexed _account,
        uint256 _ethTraded,
        uint256 _NeoTraded
    );

    LPT lpToken;
    NeoToken neoToken;
    uint256 ethReserve;
    uint256 neoReserve;

    function setLPTAddress(LPT _lpToken) external onlyOwner {
        require(address(lpToken) == address(0), "WRITE_ONCE");
        lpToken = _lpToken;
    }

    function setNeoTokenAddress(NeoToken _neoToken) external onlyOwner {
        require(address(neoToken) == address(0), "WRITE_ONCE");
        neoToken = _neoToken;
    }

    function getReserves() external view returns (uint256, uint256) {
        return (ethReserve, neoReserve);
    }

    function swap(uint256 _neoToken) external payable {
        uint256 product = ethReserve * neoReserve;
        uint256 amountToTransfer;

        if (msg.value == 0) {
            uint256 currentNeoBalance = neoToken.balanceOf(address(this));
        } else {}
    }

    function deposit(uint256 _neoToken, address _account) external payable {
        uint256 liquidity;
        uint256 totaSupply = lpToken.balanceOf(_account);
        uint256 ethAmnt = msg.value;

        if (totaSupply > 0) {
            liquidity = Math.min(
                (ethAmnt * totaSupply) / ethReserve,
                (_neoToken * totaSupply) / neoReserve
            );
        } else {
            liquidity = Math.sqrt(ethAmnt * _neoToken);
        }
        lpToken.mint(_account, liquidity);
        emit LiquidityAdded(_account);
        _update();
    }

    function withdraw(address _account)external {
        uint liquidity = lpToken.balanceOf(_account);
        require(liquidity != 0, "NO_AVAILABLE_TOKENS");

        uint totalSupply= lpToken.totalSupply();

        uint ethAmnt = (ethReserve * liquidity) / totalSupply;
        uint neoAmnt = (neoReserve * liquidity) / totalSupply;

        lpToken.burn(_account, liquidity);
        (bool ethTransferSuccess, ) = _account.call{value: ethAmnt}("");
        bool neoTransferSuccess = neoToken.transfer(_account, neoAmnt);

        require(ethTransferSuccess && neoTransferSuccess, "FAILED_TRANSFER");
        emit LiquidityRemoved(_account);
        _update();
    }

    function _update() private {
        ethReserve = address(this).balance;
        neoReserve = neoToken.balanceOf(address(this));
    }
}
