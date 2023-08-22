  function complete_sell_exchange(uint256 _amount_give) private {
    uint256 amount_get_ = get_amount_sell(_amount_give);
    uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
    uint256 platform_commission_ = (amount_get_ - amount_get_minus_commission_) / 5;
    uint256 admin_commission_ = ((amount_get_ - amount_get_minus_commission_) * 4) / 5;
    transfer_tokens_through_proxy_to_contract(msg.sender,this,_amount_give);
    transfer_eth_from_contract(msg.sender,amount_get_minus_commission_);  
    transfer_eth_from_contract(platform, platform_commission_);     
    if(admin_commission_activated) {
      transfer_eth_from_contract(admin, admin_commission_);     
    }
  }