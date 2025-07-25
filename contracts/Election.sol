// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Election {
    address payable public admin;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;

    uint public candidatesCount;

    event votedEvent(uint indexed _candidateId);

    constructor() public {
        admin = msg.sender; // pas besoin de payable ici (admin est déjà payable)
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }

    function addCandidate(string memory _name) internal {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public payable {
        require(msg.sender != admin, "Admin is not allowed to vote");
        require(!voters[msg.sender], "Already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");
        require(msg.value >= 0.01 ether, "You must send at least 0.01 ETH to vote");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        admin.transfer(msg.value); // ici pas besoin de payable(...) dans v0.5
        emit votedEvent(_candidateId);
    }
}
