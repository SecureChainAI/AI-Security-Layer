 function freezeTokens(address _owner) external onlyByOwner {
        require(TokensAreFrozen == false);
        TokensAreFrozen = true;
        emit FreezeTokensFrom(_owner);
    }