        game.expireTime = expireTimeLimit + now;
        require(now > game.expireTime || (game.dealerChoice != NONE && game.playerChoice != NONE));
        require(now < game.expireTime);
        require(now < game.expireTime);
        require(now < game.expireTime);
