 function()
        external
        payable
    {
        if (useDELEGATECALL) {
            assembly {
                /* Copy call data into free memory region. */
                let free_ptr := mload(0x40)
                calldatacopy(free_ptr, 0, calldatasize)

                /* Forward all gas and call data to the target contract. */
                let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
                returndatacopy(free_ptr, 0, returndatasize)

                /* Revert if the call failed, otherwise return the result. */
                if iszero(result) { revert(free_ptr, returndatasize) }
                return(free_ptr, returndatasize)
            }
        } else {
            /* Here we are as above, but must send the messageSender explicitly 
             * since we are using CALL rather than DELEGATECALL. */
            target.setMessageSender(msg.sender);
            assembly {
                let free_ptr := mload(0x40)
                calldatacopy(free_ptr, 0, calldatasize)

                /* We must explicitly forward ether to the underlying contract as well. */
                let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
                returndatacopy(free_ptr, 0, returndatasize)

                if iszero(result) { revert(free_ptr, returndatasize) }
                return(free_ptr, returndatasize)
            }
        }
    }