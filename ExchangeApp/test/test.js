const NeoToken = artifacts.require("NeoToken");
const LPToken = artifacts.require("LPT");
const LiquidityPool = artifacts.require("LiquidityPool");
const DEXRouter = artifacts.require("DEXRouter");


contract("Exchange App", accounts => {
    let _NeoToken, _LiquidityPool, _LPToken, _DEXRouter;
    before(async () => {
        _NeoToken = await NeoToken.deployed();
        console.log("NeoToke ", _NeoToken.address);
        _LiquidityPool = await LiquidityPool.deployed();
        console.log("LiquidityPool ",_LiquidityPool.address);
        _LPToken = await LPToken.deployed();
        console.log("LPToken ",_LPToken.address);
        _DEXRouter = await DEXRouter.deployed();
        console.log("DEXRouter ",_DEXRouter.address);
    });


    it("Should deployed all contract properly.", async () => {
        assert(_NeoToken.address !== '');
        assert(_LiquidityPool.address !== '');
        assert(_LPToken.address !== '');
        assert(_DEXRouter.address !== '');
    })

    it("1,00,000 Neo Token mint to Accounts[0]", async () => {
        let _balanceOfOwner= await _NeoToken.balanceOf(accounts[0] ,{from: accounts[0]});
        assert(_balanceOfOwner == 100000);
    })

    it("Accounts[0] - Owner transfer LPToken Contract ownership to LiquidityPool", async () => {
        await _LPToken.setLPAddress(_LiquidityPool.address);
        let LPTnewOwner= await _LPToken.owner();
        assert(LPTnewOwner == _LiquidityPool.address);
    })


    it("Owner set LPToken & NeoToken Contact address to LiquidityPool", async () => {
        await _LiquidityPool.setLPTAddress(_LPToken.address, {from: accounts[0]});
        await _LiquidityPool.setNeoTokenAddress(_NeoToken.address, {from: accounts[0]});
        let LPTAddress=  await _LiquidityPool.lpToken();
        let NeoTokenAddress= await _LiquidityPool.neoToken();
        assert(LPTAddress == _LPToken.address);
        assert(NeoTokenAddress == _NeoToken.address);
    })

    it("Owner set LiquidityPool & NeoToken contract address to Exchange App", async () => {
        await _DEXRouter.setLiquidityPoolAddress(_LiquidityPool.address, {from: accounts[0]});
        await _DEXRouter.setNeoTokenAddress(_NeoToken.address, {from: accounts[0]});
        let LiquidityPoolAddress=  await _DEXRouter.liquidityPool();
        let NeoTokenAddress= await _DEXRouter.neoToken();
        assert(LiquidityPoolAddress == _LiquidityPool.address);
        assert(NeoTokenAddress == _NeoToken.address);
    })

    it("Accounts[0] - Owner set Router address to Neo Token", async () => {
        await _NeoToken.setRouter(_DEXRouter.address,{from: accounts[0]});
        let Router= await _NeoToken.DexRouter();
        assert(Router == _DEXRouter.address);
    })

    it("Liquidity pool ETH reserve as well as Neo reserve should be 0", async () => {
        let reserve = await _LiquidityPool.getReserves();
        assert(reserve[0] == 0);
        assert(reserve[1] == 0);
    })

    it("Owner add liquidity to the pool", async () => {
        await _DEXRouter.addLiquidity(25000,{value: web3.utils.toWei("5", "ether"), from: accounts[0]});
        let reserve = await _LiquidityPool.getReserves();
        assert(reserve[0] == web3.utils.toWei("5", "ether"));
        assert(reserve[1] == 25000);
    })

    it("Accounts[1] should have Neo Token after ETH swap for Neo Token", async () => {
        let balance= await _NeoToken.balanceOf(accounts[1],{from: accounts[1]});
        assert(balance == 0);
        await _DEXRouter.swapToken(0, {value: web3.utils.toWei("1", "ether"), from: accounts[1]});
        balance= await _NeoToken.balanceOf(accounts[1],{from: accounts[1]});
        assert(balance != 0);
    })

    it("Liquidity Pool reserve should change", async ()=>{
        let reserve = await _LiquidityPool.getReserves();
        assert(reserve[0] >= web3.utils.toWei("5", "ether"));
        assert(reserve[1] <= 25000);
    })

    it("Accounts[1] should have 0 Neo Token after Neo Token swap for ETH", async () => {
        let balance= await _NeoToken.balanceOf(accounts[1],{from: accounts[1]});
        assert(balance != 0);
        await _DEXRouter.swapToken(balance, {from: accounts[1]});
        balance= await _NeoToken.balanceOf(accounts[1],{from: accounts[1]});
        assert(balance == 0);
    })  

    it("Liquidity Pool reserve should change again", async ()=>{
        let reserve = await _LiquidityPool.getReserves();
        assert(reserve[1] == 25000);
    })
})
