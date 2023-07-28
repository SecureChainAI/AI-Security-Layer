function kill() public {
    // only allow this action if the account sending the signal is the creator
    if (msg.sender == admin) {
        selfdestruct(admin); // kills this contract and sends remaining funds back to creator
    }
}
