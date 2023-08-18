            uint256 mux = token.allowance(msg.sender, this) / N[_ix][0];
                require(token.transferFrom(msg.sender, this, mux * N[_ix][i]));
                        uint256 mux = token.allowance(msg.sender, this) / N[_ix][0];
                require(token.transfer(msg.sender, M[i] * mux));

