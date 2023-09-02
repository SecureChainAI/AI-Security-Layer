function newProposal(
    address beneficiary,
    uint weiAmount,
    string jobDescription,
    bytes transactionBytecode
) public onlyShareholders returns (uint proposalID) {
    proposalID = proposals.length++;
    Proposal storage p = proposals[proposalID];
    p.recipient = beneficiary;
    p.amount = weiAmount;
    p.description = jobDescription;
    p.proposalHash = keccak256(
        abi.encodePacked(beneficiary, weiAmount, transactionBytecode)
    );
    p.minExecutionDate = now + debatingPeriodInMinutes * 1 minutes;
    p.executed = false;
    p.proposalPassed = false;
    p.numberOfVotes = 0;
    emit ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
    numProposals = proposalID + 1;

    return proposalID;
}
