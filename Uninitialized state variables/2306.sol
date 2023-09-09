function getPartnerCash(uint8 _user, address _msgsender) external canGetCash {
    require(rightAndRoles.onlyRoles(msg.sender, 1));
    require(_user < wallets.length);

    onlyPartnersOrAdmin(_msgsender);

    uint256 move = ready[_user];
    if (move == 0) return;

    emit Receive(wallets[_user], move);
    ready[_user] = 0;
    took[_user] += move;

    wallets[_user].transfer(move);
}
