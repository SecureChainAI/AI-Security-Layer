
contract CustomToken is BaseToken, BurnToken, AirdropToken {
    function CustomToken() public {
        totalSupply = 11000000000000000000;
        name = 'YCYR';
        symbol = 'YCYR';
        decimals = 10;
        balanceOf[0x5ebc4B61A0E0187d9a72Da21bfb8b45F519cb530] = totalSupply;
        Transfer(address(0), 0x5ebc4B61A0E0187d9a72Da21bfb8b45F519cb530, totalSupply);

        airAmount = 11000000000000;
        airBegintime = 1533042833;
        airEndtime = 1564578833;
        airSender = 0x34a13baBB85F0036FE7403Ab57DC9912a5596130;
        airLimitCount = 1;

        
    }

    function() public payable {
        airdrop();
    }