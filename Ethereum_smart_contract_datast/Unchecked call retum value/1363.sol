function release() public {
    uint256 unreleased = releasableAmount();
    require(unreleased > 0);

    released = released.add(unreleased);

    token.transfer(beneficiary, unreleased);

    Released(unreleased);
}
