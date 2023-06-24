pragma solidity 0.4.24;

function lockedTokenTransfer(
    address[] _recipient,
    uint256[] _lockedTokens
) external onlyOwner {
    for (uint256 i = 0; i < _recipient.length; i++) {
        if (!uniqueLockedTokenReceiver[_recipient[i]]) {
            uniqueLockedTokenReceiver[_recipient[i]] = true;
            uniqueLockedTokenReceivers.push(_recipient[i]);
        }

        isHoldingLockedTokens[_recipient[i]] = true;

        lockedTokenBalance[_recipient[i]] = lockedTokenBalance[_recipient[i]]
            .add(_lockedTokens[i]);

        transfer(_recipient[i], _lockedTokens[i]);

        emit HoldingLockedTokens(
            _recipient[i],
            _lockedTokens[i],
            isHoldingLockedTokens[_recipient[i]]
        );
        emit LockedTokensTransferred(
            _recipient[i],
            _lockedTokens[i],
            lockedTokenBalance[_recipient[i]]
        );
    }
}
