pragma solidity ^0.4.18;
pragma solidity ^0.4.18;

function claimTokens(address _token) public onlyController {
    if (_token == 0x0) {
        controller.transfer(this.balance);
        return;
    }

    MiniMeToken token = MiniMeToken(_token);
    uint balance = token.balanceOf(this);
    token.transfer(controller, balance);
    ClaimedTokens(_token, controller, balance);
}
