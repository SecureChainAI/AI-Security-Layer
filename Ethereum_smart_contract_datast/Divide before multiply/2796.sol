    players[keyAddress].balance += poolBalance / 5 * 75 / 100;
            players[keyAddress].lastKeyBonus += poolBalance / 5 * 75 / 100;
                players[keyAddress].balance += poolBalance / 5 * 15 / 100;
                players[keyAddress].lastKeyBonus += poolBalance / 5 * 15 / 100;
               players[participantPool[randParticipantIndex - 1]].balance += poolBalance / 5 * 15 / 100;
                players[participantPool[randParticipantIndex - 1]].lastKeyBonus += poolBalance / 5 * 15 / 100;
            residualBalance += poolBalance / 5 * 10 / 100 + potReserve;
		    unitStake = amount * 58 / 100 / poolWeight;
		            players[_addr].balance += players[_addr].weight * unitStake;
		        deltaStake = amount * 15 / 100 / poolWeight;
		            if(players[_addr].generation == currentGeneration) {
		                players[_addr].stakingBonus += players[_addr].weight * deltaStake;
