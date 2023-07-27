 function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
        return freezingBalance[_owner];
    }