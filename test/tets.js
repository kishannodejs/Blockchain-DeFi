const ERC20 = artifacts.require("ERC20");

contract("ERC20 Develope", accounts => {
    let _ERC20;
    before(async () => {
        _ERC20 = await ERC20.deployed();
        console.log(_ERC20.address);
    });


    it("Should deployed NFT Market Place properly.", async () => {
        assert(_ERC20.address !== '');
    })

    it("Name and Symbol of token should be correct", async () => {
        let _nameToken= await _ERC20.name({from: accounts[1]});
        let _symbolToken= await _ERC20.symbol({from: accounts[1]});
        assert(_nameToken == "Neo");
        assert(_symbolToken == "NS");
    })

    it("owner token mint supply should be 10000", async () => {
        await _ERC20.mint(10000, {from: accounts[1]});
        let _totalSupply= await _ERC20.totalSupply({from: accounts[1]});
        assert(_totalSupply == 10000);
    })

    it("balance of", async () => {
        let _totalSupply= await _ERC20.balanceOf(accounts[1]);
        assert(_totalSupply == 10000);
    })

    it("transfer balance ", async () => {
        let result= await _ERC20.transfer(accounts[0],1000,{from: accounts[1]});
        assert(result.logs[0].event == "Transfer");
    })   

    it("balance of", async () => {
        let _totalSupply= await _ERC20.balanceOf(accounts[0]);
        assert(_totalSupply == 1000);
    })

})