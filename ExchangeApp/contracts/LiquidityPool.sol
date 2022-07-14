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
        uint256 _neoTraded
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

    function _update() private {
        ethReserve = address(this).balance;
        neoReserve = neoToken.balanceOf(address(this));
    }
}
