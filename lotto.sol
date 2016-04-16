import "./rng.sol";

contract lotto {
	
	struct userBet {
		uint tickets;
		address user;
	}
	
	uint uniqueUsersThreshold = 20;
	uint8 numOfBlocks;
	uint betValue;
	userBet[] bets;
	bytes32 lotteryClosingHash = 0;
	
	uint userAccountStatus;
	
	function lotto(uint _uniqueUsersThreshold, uint8 _numOfBlocks, uint _betValue){
		uniqueUsersThreshold = _uniqueUsersThreshold;
		numOfBlocks = _numOfBlocks;
		betValue = _betValue;
	}
	
	function bet() canBet {
		uint amount = msg.value;
		
		// do not accept bet 
		// if amount of Ether is lower than betValue
		if (amount < betValue){
			throw;
		}
		
		uint tickets = amount / betValue;
		
		// if amount of Ether is not divided by betValue
		// send rest of the money to the better
		uint amountToReturn = amount % betValue;
		if(amountToReturn != 0) {
			msg.sender.send(amountToReturn);
		}
	
		userBet memory current;
		for ( uint i= 0; i < bets.length; i++){
			if(bets[i].user == msg.sender) {
				current = bets[i];
				break;
			}
		}
		if (current.user != 0) {
			current.tickets += tickets;
		} else {
			current = userBet(tickets, msg.sender);
			bets.push(current);
		}
		
		if (bets.length >= uniqueUsersThreshold){
			//TODO: change index of block before release
			lotteryClosingHash = block.blockhash(0);
		}
	}
	
	modifier canBet {
		if (lotteryClosingHash != 0) throw; _
	}

	
	function draw() returns (uint randomNumber){	
		return new rng().getRandom(block.blockhash(0), 2, 10);
	}
	
	function getWinner(uint id) returns(address winner) {
		uint sum = 0;
		for (uint i = 0; i < uniqueUsersThreshold; i++){
			
		}
		
//		if (id >= bets.length ){
//			throw;
//		}		
//		return bets[id];
	}
	
	function payout(address winner) {
		winner.send(this.balance);
	}
}