pragma solidity 0.8.13;

import "./Dependencies.sol";

contract InsecureAirdrop {
    mapping (address => uint256) private userBalances;
    mapping (address => bool) private receivedAirdrops;

    uint256 public immutable airdropAmount;

    constructor(uint256 _airdropAmount) {
        airdropAmount = _airdropAmount;
    }

    function receiveAirdrop() external neverReceiveAirdrop canReceiveAirdrop {
        // Mint Airdrop
        userBalances[msg.sender] += airdropAmount;
        receivedAirdrops[msg.sender] = true;
    }

    modifier neverReceiveAirdrop {
        require(!receivedAirdrops[msg.sender], "You already received an Airdrop");
        _;
    }

    // In this example, the _isContract() function is used for checking 
    // an airdrop compatibility only, not checking for any security aspects
    function _isContract(address _account) internal view returns (bool) {
        // It is unsafe to assume that an address for which this function returns 
        // false is an externally-owned account (EOA) and not a contract
        uint256 size;
        assembly {
            // There is a contract size check bypass issue
            // But, it is not the scope of this example though
            size := extcodesize(_account)
        }
        return size > 0;
    }

    modifier canReceiveAirdrop() {
        // If the caller is a smart contract, check if it can receive an airdrop
        if (_isContract(msg.sender)) {
            // In this example, the _isContract() function is used for checking 
            // an airdrop compatibility only, not checking for any security aspects
            require(
                IAirdropReceiver(msg.sender).canReceiveAirdrop(), 
                "Receiver cannot receive an airdrop"
            );
        }
        _;
    }
}