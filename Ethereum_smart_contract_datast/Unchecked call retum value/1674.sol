function emergencyERC20Drain(ERC20 oddToken, uint amount) public onlyLauncher {
    if (address(oddToken) == address(0)) {
        launcher.transfer(amount);
        return;
    }
    oddToken.transfer(launcher, amount);
}
