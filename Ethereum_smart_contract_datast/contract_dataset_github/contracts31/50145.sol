pragma solidity ^0.6.0;

import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


//10000000000000000 = 0.01ETH
//ETH Kovan:  0xd0a1e359811322d97991e03f863a0c30c2cf029c
//DAI Kovan:  0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa
//USDC Kovan: 0x198419c5c340e8de47ce4c0e4711a03664d42cb2
//LINK Kovan: 0xa36085F69e2889c224210F603D836748e7dC0088

contract ArbRunner {
    
    using SafeMath for uint256;
    address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapV2Router02 public uniswapRouter;
    
    
     constructor() public {
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
    }
    
    
    
     function Execute2TokenUniswap(uint256 _ethIn, address _token1, address _token2) public  {
        uint deadline = now + 60;

        
		address[] memory path1 = new address[](2);
        //path1[0] = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); //ETH Main net
		path1[0] = address(0xd0A1E359811322d97991E03f863a0C30C2cF029C); //ETH Kovan
        path1[1] = address(_token1);
        

        uint[] memory swap1Amounts = uniswapRouter.swapExactETHForTokens{value: _ethIn}(
            1,
            path1,
            address(this),
            deadline
        );
        uint256 swap1Output = swap1Amounts[1];
        IERC20(_token1).approve(address(UNISWAP_ROUTER_ADDRESS), swap1Output+1);
        
        
        address[] memory path2 = new address[](2);
        path2[0] = address(_token1);
        path2[1] = address(_token2);

        //uint[] memory minOuts2 = uniswapRouter.getAmountsOut(swap1Output, path2); 
        uint[] memory swap2Amounts = uniswapRouter.swapExactTokensForTokens(
            swap1Output,
            1, 
            path2,
            address(this),
            deadline
        );
        uint256 swap2Output = swap2Amounts[1];
        IERC20(_token2).approve(address(UNISWAP_ROUTER_ADDRESS), swap2Output+1);
        
        
        address[] memory path3 = new address[](2);
        path3[0] = address(_token2);
        //path3[1] = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); //ETH Main net
        path3[1] = address(0xd0A1E359811322d97991E03f863a0C30C2cF029C); //ETH Kovan

        //uint[] memory minOuts3 = uniswapRouter.getAmountsOut(swap2Output, path3); 
        uint[] memory swap3Amounts = uniswapRouter.swapExactTokensForETH(
          swap2Output,
          1,
          path3, 
          address(this), 
          deadline
         );
        
    }
    
   receive() external payable {}
   
}

