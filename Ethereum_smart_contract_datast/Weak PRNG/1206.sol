        uint _decision = uint(keccak256(keccak256(blockhash(block.number),_preset),now))%(_price);
