                rewards[_to].push(Payment({time : now, amount : amount}));
 if(sum > 0) {
                _to.transfer(sum);
                emit Reward(_to, now, sum);
            }
            