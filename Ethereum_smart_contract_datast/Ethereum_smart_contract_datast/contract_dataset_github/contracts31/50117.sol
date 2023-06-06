pragma solidity ^0.4.18;

import "./PoDs/SimplePoD.sol";
import "./PoDs/TokenMintPoD.sol";

contract ContractManager {

  /**
   * Storage
   */
  string public name = "ContractManager";
  string public version = "0.9.3";

  /**
   * constructor
   * @dev define owner when this contract deployed.
   */

  function ContractManager() public {}

  /**
   * @dev deploy a new contract instance.
   * @param _rico         address of rico.
   * @param _mode         Token name of RICO format.
   * @param _decimals     Token decimals of RICO format.
   * @param _wallet       Founder's multisig wallet.
   * @param _params       parameters of pod.
   */

  function deploy(
    address _rico,
    uint _mode,
    uint8 _decimals,
    address _wallet,
    uint256[] _params
  )
  public returns (address)
  {
    if (_mode == 0) {
      SimplePoD pod = new SimplePoD();
      uint256 period = 7 days;
      pod.init(_wallet, _decimals, _params[0], _params[1], _params[2], period);

      /*hardCap = _params[1];
      startTime = _params[0];
      endTime = startTime + period;
      wallet = _wallet;*/

      pod.transferOwnership(_rico);
      return address(pod);
    }
    if (_mode == 1) {
      TokenMintPoD mint = new TokenMintPoD();
      mint.init(_wallet, _params[0], _params[1]);
      mint.transferOwnership(_rico);
      return address(mint);
    }
  }
}
