function withdrawAll() public onlyAdmins {
    msg.sender.transfer(address(this).balance);
}

function withdrawAmount(uint256 _amount) public onlyAdmins {
    msg.sender.transfer(_amount);
}
