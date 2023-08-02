  function freeze(address[] _targets, bool _value) public onlyOwner returns(bool success) {
    require(_targets.length > 0);
    require(_targets.length <= 255);
    for (uint8 i = 0; i < _targets.length; i++) {
      assert(_targets[i] != 0x0);
      frozens[_targets[i]] = _value;
      emit Frozen(_targets[i], _value);
    }
    return true;
  }