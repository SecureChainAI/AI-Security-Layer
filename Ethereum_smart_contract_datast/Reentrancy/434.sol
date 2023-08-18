 function createChildren(uint32 _matron, uint32 _sire) public  payable returns(uint32) {

        require(isPriv());
        require(isPauseSave());
        require(rabbitToOwner[_matron] == msg.sender);
        // Checking for the role
        require(rabbits[(_sire-1)].role == 1);
        require(_matron != _sire);

        require(getBreed(_matron));
        // Checking the money 
        
        require(msg.value >= getSirePrice(_sire));
        
        uint genome = getGenomeChildren(_matron, _sire);

        uint localdnk =  privateContract.mixDNK(mapDNK[_matron], mapDNK[_sire], genome);
        Rabbit memory rabbit =  Rabbit(_matron, _sire, block.number, 0, 0, 0, genome);

        uint32 bunnyid =  uint32(rabbits.push(rabbit));
        mapDNK[bunnyid] = localdnk;


        uint _moneyMother = rabbitSirePrice[_sire].div(4);

        _transferMoneyMother(_matron, _moneyMother);

        rabbitToOwner[_sire].transfer(rabbitSirePrice[_sire]);

        uint system = rabbitSirePrice[_sire].div(100);
        system = system.mul(commission_system);
        ownerMoney.transfer(system); // refund previous bidder
  
        coolduwnUP(_matron);
        // we transfer the rabbit to the new owner
        transferNewBunny(rabbitToOwner[_matron], bunnyid, localdnk, genome, _matron, _sire);   
        // we establish parents for the child
        setRabbitMother(bunnyid, _matron);
        return bunnyid;
    } 