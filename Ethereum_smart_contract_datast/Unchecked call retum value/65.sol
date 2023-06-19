pragma solidity ^0.4.23;

function transfer(address _to, uint _amount) external view {
    // Begin execution - reads execution id and original sender address from storage
    Contract.authorize(msg.sender);
    // Check that the token is initialized -
    Contract.checks(tokenInit);
    // Execute transfer function -
    Transfer.transfer(_to, _amount);
    // Ensures state change will only affect storage and events -
    Contract.checks(emitAndStore);
    // Commit state changes to storage -
    Contract.commit();
}

/*
  Allows an approved spender to transfer tokens to another address on an owner's behalf

  @param _owner: The address from which tokens will be sent
  @param _recipient: The destination to which tokens will be sent
  @param _amount: The number of tokens to transfer
  */
function transferFrom(
    address _owner,
    address _recipient,
    uint _amount
) external view {
    // Begin execution - reads execution id and original sender address from storage
    Contract.authorize(msg.sender);
    // Check that the token is initialized -
    Contract.checks(tokenInit);
    // Execute transfer function -
    Transfer.transferFrom(_owner, _recipient, _amount);
    // Ensures state change will only affect storage and events -
    Contract.checks(emitAndStore);
    // Commit state changes to storage -
    Contract.commit();
}

/*
  Approves a spender to spend an amount of your tokens on your behalf

  @param _spender: The address allowed to spend your tokens
  @param _amount: The number of tokens that will be approved
  */
function approve(address _spender, uint _amount) external view {
    // Begin execution - reads execution id and original sender address from storage
    Contract.authorize(msg.sender);
    // Check that the token is initialized -
    Contract.checks(tokenInit);
    // Execute approval function -
    Approve.approve(_spender, _amount);
    // Ensures state change will only affect storage and events -
    Contract.checks(emitAndStore);
    // Commit state changes to storage -
    Contract.commit();
}
