  amount = ((
                _valuation.mul(oracle_price_decimals_factor)
            ).div(
                _art_price
            )).mul(decimal_precission_difference_factor);
            _shares_to_assign = _executed_amount_valuation.div(_final_share_price);
            _executed_amount_valuation = _shares_to_assign.mul(_final_share_price);
