 function decision(bytes32 _preset, string _presetSrc, address[] _buyers, uint[] _amounts) onlyOwner public payable{
        
        // execute it only once
        require(DC.getDecision(_preset) == address(0));

        // preset authenticity
        require(sha256(_presetSrc) == DC.getGoodPreset(_preset));

        // address added, parameter 1
        uint160 allAddress;
        for (uint i = 0; i < _buyers.length; i++) {
            allAddress += uint160(_buyers[i]);
        }
        
        // random, parameter 2
        uint random = _random();

        uint goodPrice = DC.getGoodPrice(_preset);

        // preset is parameter 3, add and take the remainder
        uint result = uint(uint(_stringToBytes32(_presetSrc)) + allAddress + random) % goodPrice;

        address finalAddress = _getFinalAddress(_amounts, _buyers, result);
        // save decision result
        DC.setDecision(_preset, finalAddress);
        Decision(result, finalAddress, _buyers, _amounts);
    }