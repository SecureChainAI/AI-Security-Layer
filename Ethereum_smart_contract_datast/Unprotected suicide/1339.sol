function kill() public manageronly {
    selfdestruct(binanceContribute); // kills this contract and sends remaining funds back to creator
}
