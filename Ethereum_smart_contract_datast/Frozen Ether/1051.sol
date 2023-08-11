 function freezingBalanceNumberOf(address addr) constant public returns (uint) {
        return c_freezing_list[addr].length;
    }

 function freezingBalanceInfoOf(address addr, uint index) constant public returns (uint, uint, uint8) {
        return (c_freezing_list[addr][index].end_stamp, c_freezing_list[addr][index].num_lccs, uint8(c_freezing_list[addr][index].freezing_type));
    }