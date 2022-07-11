const DeFi = artifacts.require("DeFi");

contract("DeFi 100% withdraw", accounts => {
    let _DeFi;
    before(async () => {
        _DeFi = await DeFi.deployed();
        console.log(_DeFi.address);
    });


    it("Should deployed Contract properly.", async () => {
        assert(_DeFi.address !== '');
    })

    it("Transaction should be fail due to msg.value less than 1 ETH", async () => {
        let error;
        await _DeFi.lendETH({ value: 50000000000000000, from: accounts[0] }).then().catch(err => { error = err.reason });
        assert(error == "Minimum lend amount should be 1 ether");
    })

    it("DeFi Contract balance should be 1 ETH after Accounts[0] lending", async () => {
        await _DeFi.lendETH({ value: web3.utils.toWei("1", "ether"), from: accounts[0] });
        let _contarctBal = await _DeFi.getBal({ from: accounts[0] });
        assert(_contarctBal == web3.utils.toWei("1", "ether"));
    })

    it("Accounts[0] should get 100 NeoToken in exchange of 1 ETH", async () => {
        let _Acc0Lend = await _DeFi.balanceOf(accounts[0], { from: accounts[0] });
        assert(_Acc0Lend == 100);
    })

    it("Accounts[0] should borrow 1 ETH in exchange of 100 NeoToken", async () => {
        await _DeFi.borrowETH(100, { from: accounts[0] });
        let _contarctTokenBal = await _DeFi.balanceOf(_DeFi.address, { from: accounts[0] });
        assert(_contarctTokenBal == 100);
    })

    it("Token balance of accounts[0] should be 0", async () => {
        let _userTokenBal = await _DeFi.balanceOf(accounts[0], { from: accounts[0] });
        assert(_userTokenBal == 0);
    })

    it("ETH balance of DeFi Contract should be 0", async () => {
        let _contractETHbal = await _DeFi.getBal({ from: accounts[0] });
        assert(_contractETHbal == 0);
    })

})

contract("DeFi 50% withdraw", accounts => {
    let _DeFi;
    before(async () => {
        _DeFi = await DeFi.deployed();
        console.log(_DeFi.address);
    });


    it("Should deployed Contract properly.", async () => {
        assert(_DeFi.address !== '');
    })

    it("DeFi Contract balance should be 2 ETH after Accounts[0] lending", async () => {
        await _DeFi.lendETH({ value: web3.utils.toWei("2", "ether"), from: accounts[0] });
        let _contarctBal = await _DeFi.getBal({ from: accounts[0] });
        assert(_contarctBal == web3.utils.toWei("2", "ether"));

    })

    it("Accounts[0] should get 200 NeoToken in exchange of 2 ETH", async () => {
        let _Acc0Lend = await _DeFi.balanceOf(accounts[0], { from: accounts[0] });
        assert(_Acc0Lend == 200);
    })

    it("Accounts[0] should borrow 1 ETH in exchange of 100 NeoToken", async () => {
        await _DeFi.borrowETH(100, { from: accounts[0] });
        let _contarctTokenBal = await _DeFi.balanceOf(_DeFi.address, { from: accounts[0] });
        assert(_contarctTokenBal == 100);
    })

    it("Token balance of accounts[0] should be 100", async () => {
        let _userTokenBal = await _DeFi.balanceOf(accounts[0], { from: accounts[0] });
        assert(_userTokenBal == 100);
    })

    it("ETH balance of DeFi Contract should be 1", async () => {
        let _contractETHbal = await _DeFi.getBal({ from: accounts[0] });
        assert(_contractETHbal == web3.utils.toWei("1", "ether"));
    })

})