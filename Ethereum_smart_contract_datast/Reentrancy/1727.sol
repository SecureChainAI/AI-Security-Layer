  function complete_sell_exchange(uint256 _amount_give) private {

    uint256 amount_get_ = get_amount_sell(_amount_give);


    // this is the amount that is transferred to the seller -minus the commision ANYWAY (even if admin_commission_activated is False) 
    uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
    
    transferTokensThroughProxyToContract(msg.sender,this,_amount_give);


    // the commission is transferred to admin only if admin_commission_activated, but the commission is subtracted anyway
    if(admin_commission_activated) {
      transferETHFromContract(msg.sender,amount_get_minus_commission_);

      uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;

      transferETHFromContract(admin, admin_commission_);     

    }
    else {
      transferETHFromContract(msg.sender,amount_get_);
    }
  }