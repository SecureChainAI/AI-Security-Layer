pragma solidity ^0.4.23;

function exec(
    bytes32 _exec_id,
    bytes _calldata
) external payable returns (bool success) {
    // Get function selector from calldata -
    bytes4 sel = getSelector(_calldata);
    // Ensure no registry functions are being called -
    require(
        sel != this.registerApp.selector &&
            sel != this.registerAppVersion.selector &&
            sel != UPDATE_INST_SEL &&
            sel != UPDATE_EXEC_SEL
    );

    // Call 'exec' in AbstractStorage, passing in the sender's address, the app exec id, and the calldata to forward -
    if (
        address(app_storage).call.value(msg.value)(
            abi.encodeWithSelector(EXEC_SEL, msg.sender, _exec_id, _calldata)
        ) == false
    ) {
        // Call failed - emit error message from storage and return 'false'
        checkErrors(_exec_id);
        // Return unspent wei to sender
        address(msg.sender).transfer(address(this).balance);
        return false;
    }

    // Get returned data
    success = checkReturn();
    // If execution failed,
    require(success, "Execution failed");

    // Transfer any returned wei back to the sender
    address(msg.sender).transfer(address(this).balance);
}
