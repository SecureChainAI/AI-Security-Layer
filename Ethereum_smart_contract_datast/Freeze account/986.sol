	function freezeAccount(address target,bool _bool)  public onlyOwner{
        if(target != 0){
            frozenAccount[target] = _bool;
        }
    }