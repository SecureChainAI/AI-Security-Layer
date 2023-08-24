        if (msg.sender==owner && now <= icoDeadLine)                    // ICO Reserve Supply checking: Don't touch the RESERVE of tokens when owner is selling
        require(msg.sender==owner && now>icoDeadLine);
