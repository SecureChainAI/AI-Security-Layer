function isAccount(address _address) internal view returns (bool result) {
    assembly {
        result := iszero(extcodesize(_address))
    }
}

function toBytes(address _address) internal pure returns (bytes b) {
    assembly {
        let m := mload(0x40)
        mstore(
            add(m, 20),
            xor(0x140000000000000000000000000000000000000000, _address)
        )
        mstore(0x40, add(m, 52))
        b := m
    }
}
