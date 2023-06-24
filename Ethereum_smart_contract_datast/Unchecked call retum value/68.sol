pragma solidity ^0.4.23;

function buffPtr() private pure returns (bytes32 ptr) {
    assembly {
        ptr := mload(0xc0)
    }
}

function execID() internal pure returns (bytes32 exec_id) {
    assembly {
        exec_id := mload(0x80)
    }
    require(exec_id != bytes32(0), "Execution id overwritten, or not read");
}

function sender() internal pure returns (address addr) {
    assembly {
        addr := mload(0xa0)
    }
    require(addr != address(0), "Sender address overwritten, or not read");
}

function expected() private pure returns (NextFunction next) {
    assembly {
        next := mload(0x100)
    }
}

function toBytes4Arr(
    bytes32[] memory _arr
) internal pure returns (bytes4[] memory _conv) {
    assembly {
        _conv := _arr
    }
}

function toAddressArr(
    bytes32[] memory _arr
) internal pure returns (address[] memory _conv) {
    assembly {
        _conv := _arr
    }
}

function toUintArr(
    bytes32[] memory _arr
) internal pure returns (uint[] memory _conv) {
    assembly {
        _conv := _arr
    }
}
