        require(target.delegatecall(bytes4(keccak256("initialize()"))));
            ret:=delegatecall(sub(gas, 10000), target, 0x0, calldatasize, 0, len)
