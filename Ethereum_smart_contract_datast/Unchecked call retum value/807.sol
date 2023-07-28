function owner() public view returns (address) {}

function name() public view returns (string) {}

contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external

    function symbol() public view returns (string) {}

    function decimals() public view returns (uint8) {}

    function totalSupply() public view returns (uint256) {}

    function balanceOf(address _owner) public view returns (uint256) {
        _owner;
    }
}
