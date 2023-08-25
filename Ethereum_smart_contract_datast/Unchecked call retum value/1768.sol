function withdraw_arbitrary_token(address _token) public only_admin {
    require(_token != traded_token);
    Token(_token).transfer(admin, Token(_token).balanceOf(address(this)));
}
