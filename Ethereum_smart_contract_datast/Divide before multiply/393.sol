 uint daysPassed=(now.sub(dayStartTime)).div(timestep);
            dayStartTime=dayStartTime.add(daysPassed.mul(timestep));