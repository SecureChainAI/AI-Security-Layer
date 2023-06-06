pragma solidity =0.5.16;

import '@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20Detailed, ERC20 {
  constructor() ERC20Detailed('Test Token', 'TTK', 18) public {}
}