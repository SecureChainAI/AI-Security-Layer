        require(now<gameExpiry);
        return ((now < expiry) && !expired);
        require(isNotExpired() && value!=0 && msg.sender==mainContract && sideData[StringYokes.zint_convert(betSide)].isValidSide);
        require(!expired && (mainContract==msg.sender) && ((sentBy==gameMaker) || now > getExpiryTime() + 259200));
