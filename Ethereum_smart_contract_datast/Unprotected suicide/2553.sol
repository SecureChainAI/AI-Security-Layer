  function kill(address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
        selfdestruct(_to);
    }
    