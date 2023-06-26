pragma solidity ^0.5.4;

import '../Staker.sol';

contract StakerMock is Staker {
	uint256 public _time;

    constructor(address _touch, address _stable, address _compound)
    	Staker(_touch, _stable, _compound)
    	public {
    }

	function getTime() public view returns (uint256) {
		return _time;
	}

	function setTime(uint256 __time) public {
		_time = __time;
	}

	function forward1day() public {
		_time = _time + 1 days;
	}

	function forward10days() public {
		_time = _time + 10 days;
	}
}
