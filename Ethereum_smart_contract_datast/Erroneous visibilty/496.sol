function balanceOf(address tokenOwner) view returns (uint) {
    return balances[tokenOwner];
}

function transfer(address to, uint tokens) returns (bool) {
    balances[msg.sender] = sub(balances[msg.sender], tokens);
    balances[to] += tokens;
    emit Transfer(msg.sender, to, tokens);
    return true;
}

function transferFrom(address from, address to, uint tokens) returns (bool) {
    // subtract tokens from both balance and allowance, fail if any is smaller
    balances[from] = sub(balances[from], tokens);
    allowed[from][msg.sender] = sub(allowed[from][msg.sender], tokens);
    balances[to] += tokens;
    emit Transfer(from, to, tokens);
    return true;
}

function approve(address spender, uint tokens) returns (bool) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
}

function allowance(address tokenOwner, address spender) view returns (uint) {
    return allowed[tokenOwner][spender];
}

function burn(uint tokens) {
    balances[msg.sender] = sub(balances[msg.sender], tokens);
    totalSupply -= tokens;
    emit Burn(msg.sender, tokens);
}
