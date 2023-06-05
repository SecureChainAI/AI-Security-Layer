pragma solidity >=0.4.23 <0.6.0;

contract StringUtils {
    function concat(string memory _base, string memory _value)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length > 0);

        string memory _tmpValue = new string(_baseBytes.length +
            _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for (i = 0; i < _baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for (i = 0; i < _valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }
    
    function addressToString(address _addr) internal pure returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";
    
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }
    
    function uintToAscii(uint8 number) internal pure returns(byte) {
        if (number < 10) {
            return byte(48 + number);
        } else if (number < 16) {
            return byte(87 + number);
        } else {
            revert();
        }
    }
    function bytes32ToString(bytes32 data) public pure returns (string memory) {
        bytes memory bytesString = new bytes(64);
        for (uint j=0; j < 32; j++) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            bytesString[j*2+0] = uintToAscii(uint8(char) / 16);
            bytesString[j*2+1] = uintToAscii(uint8(char) % 16);
        }
        return concat('0x', string(bytesString));
    }
}