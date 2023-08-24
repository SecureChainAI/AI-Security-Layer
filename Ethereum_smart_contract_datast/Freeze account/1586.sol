 function freezeAccount(address _wallet) public onlyOwner {
        require(
            _wallet != address(0),
            "Address must be not empty"
        );
        frozenList[_wallet] = true;
        emit FrozenFunds(_wallet, true);
    }