contract SafeDestructible is Ownable {
    function destroy() public onlyOwner {
        require(this.balance == 0);
        selfdestruct(owner);
    }
}
