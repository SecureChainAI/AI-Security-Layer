			fee = msg.value.div(FEE_DEV);
			contributor.fee_devs += fee*2;
			fees = fees.add(fee*2);
