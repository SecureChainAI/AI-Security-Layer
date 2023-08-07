function transferFrom(
    address src,
    address dst,
    uint256 wad
) public stoppable returns (bool) {
    bool retVal = logic.transferFrom(src, dst, wad);
    if (retVal) {
        uint codeLength;
        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(dst)
        }
        if (codeLength > 0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(dst);
            bytes memory empty;
            receiver.tokenFallback(src, wad, empty);
        }

        Transfer(src, dst, wad);
    }
    return retVal;
}
