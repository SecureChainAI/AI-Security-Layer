function _withdrawBalance() internal {
    // We are using this boolean method to make sure that even if one fails it will still work
    bankManager.transfer(address(this).balance);
}
