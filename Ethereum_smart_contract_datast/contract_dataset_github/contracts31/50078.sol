pragma solidity ^0.6.0;


contract Any_Price {
    
    address public UNIfactory;
    address public wETHaddress;
    address public owner;
 

    function getUNIpair(address _token) internal view returns(address) {
        return IUniswapV2Factory(UNIfactory).getPair(_token, wETHaddress);
    }

    function _getUint256Reserves(address _token) internal view returns(uint256 rToken, uint256 rWETH) {
        address _UNIpair = getUNIpair(_token);
                
        address _token0 = IUniswapV2Pair(_UNIpair).token0(); 
        address _token1 = IUniswapV2Pair(_UNIpair).token1(); 
        require(_token0 == wETHaddress || _token1 == wETHaddress);
        
        uint112 _rTKN; uint112 _rWETH;
        
        if(_token0 == wETHaddress) {
        (_rWETH, _rTKN, ) = IUniswapV2Pair(_UNIpair).getReserves(); //returns r0, r1, time
        }
        else {
        (_rTKN, _rWETH, ) = IUniswapV2Pair(_UNIpair).getReserves();
        }
        
        return (uint256(_rTKN),uint256(_rWETH)); //price in gwei, needs to be corrected by nb of decimals of _token
         //price of 1 token in GWEI
    }  
    
    function adjuster(address _token) internal view returns(uint256) {
        uint8 _decimals = _ERC20(_token).decimals();
        require(_decimals <= 18,"OverFlow risk, not supported");
        uint256 _temp = 36 - uint256(_decimals);
        return 10**_temp;
    }
    
    function getUNIprice(address _token) internal view returns(uint) {

        uint256 rToken; uint256 rWETH; uint256 _adjuster;
        (rToken, rWETH) = _getUint256Reserves(_token);
        _adjuster = adjuster(_token);
        

        return ( (rToken).mul(_adjuster) ).div(rWETH);       //IN GWEI
    }
    
    function getTokenInfo(address _token) public view returns(
        string memory name, string memory symbol, uint8 decimals, address uniPair, uint256 tokensPerETH) {
        return(
            _ERC20(_token).name(), 
            _ERC20(_token).symbol(), 
            _ERC20(_token).decimals(), 
            getUNIpair(_token), 
            getUNIprice(_token)
        ); //normalized as if every token is 18 decimals
    }
}
