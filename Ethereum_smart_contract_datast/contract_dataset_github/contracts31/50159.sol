pragma solidity ^0.4.18;

import "./ContractManager.sol";
import "./RICO.sol";

contract Launcher {

  /**
   * Storage
   */
  string public name = "RICO Launcher";
  string public version = "0.9.3";
  RICO public rico;
  ContractManager public cm;
  bool state = false;

  /**
   * constructor
   * @dev define owner when this contract deployed.
   */

  function Launcher() public {}

  /**
   * @dev init rico contract.
   * @param _rico         set rico address.
   */
  function init(address _rico, address _cm) public {
    require(!state);
    rico = RICO(_rico);
    cm = ContractManager(_cm);
    state = true;
  }

  function simpleICO(
    string _name,
    string _symbol,
    uint8 _decimals,
    address _wallet,
    uint256[] _podParams,
    uint256[] _mintParams
  )
  public returns (address)
  {
    address[] memory pods = new address[](2);
    pods[0] = cm.deploy(rico, 0, _decimals, _wallet, _podParams);
    pods[1] = cm.deploy(rico, 1, _decimals, _wallet, _mintParams);

    return rico.newProject(_name, _symbol, _decimals, pods, _wallet);

  }
}
