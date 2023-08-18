function freeze(address _address, bool _state) public onlyOwner returns (bool) {
		frozenAccount[_address] = _state;

		emit Freeze(_address, _state);

		return true;
	}