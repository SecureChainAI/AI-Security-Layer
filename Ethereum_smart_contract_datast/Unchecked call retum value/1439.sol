function _bytes32(string _input) internal pure returns (bytes32 result) {
    assembly {
        result := mload(add(_input, 32))
    }
}

function _assemblyCall(
    address _destination,
    uint _value,
    bytes _data
) internal returns (bool success) {
    assembly {
        success := call(
            gas,
            _destination,
            _value,
            add(_data, 32),
            mload(_data),
            0,
            0
        )
    }
}
