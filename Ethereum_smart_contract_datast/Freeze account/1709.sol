    function freeze(address _account, uint _totalAmount)
        public
        onlyOwner
    {
        frozenAccount[_account] = true;
        frozenTokens[_account][0] = _totalAmount;            // 100% of locked token within 6 months
    }