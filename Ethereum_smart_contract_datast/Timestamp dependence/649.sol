          require(block.timestamp < releaseTime);
      require(tokenTotal == token.balanceOf(this));
      if(tokenTotal>token.balanceOf(this)){
    require(block.timestamp >= releaseTime);
    if(released_times>=lock_quarter){
