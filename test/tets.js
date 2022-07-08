const NeoToken = artifacts.require("NeoToken");

contract("NeoToken Develope", accounts => {
    let _NeoToken;
    before(async () => {
        _NeoToken = await NeoToken.deployed();
        console.log(_NeoToken.address);
    });


    it("Should deployed NeoToken properly.", async () => {
        assert(_NeoToken.address !== '');
    })

    it("Name, Symbol and Total Supply of token should be correct", async () => {
        let _nameToken= await _NeoToken.name({from: accounts[0]});
        let _symbolToken= await _NeoToken.symbol({from: accounts[0]});
        let _totalSupply= await _NeoToken.totalSupply({from: accounts[0]});
        assert(_nameToken == "NeoToken");
        assert(_symbolToken == "NT");
        assert(_totalSupply == 100000);
    })

    // it("balance of accounts[0] should be 100000", async () => {
    //     let _balanceOf= await _NeoToken.balanceOf(accounts[0]);
    //     assert(_balanceOf == 100000);
    // })

    it("transfer balance 1000 Neo from accounts[0] to accounts[1]", async () => {
        let result= await _NeoToken.transfer(accounts[1],1000,{from: accounts[0]});
        assert(result.logs[0].event == "Transfer");
    })   

    it("balance of accounts[1] should be 1000", async () => {
        let _totalSupply= await _NeoToken.balanceOf(accounts[1]);
        assert(_totalSupply == 1000);
    })

})