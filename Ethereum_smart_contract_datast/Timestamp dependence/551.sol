            if( stage == Stages.PREICO && now <= pre_enddate ) { 
            else if (stage == Stages.ICO && now <= ico_fourth ) {
                if( now < ico_first )
                else if( now >= ico_first && now < ico_second )
                else if( now >= ico_second && now < ico_third )
                else if( now >= ico_third && now < ico_fourth )
        require(now > pre_enddate);
        require(now > ico_fourth);
