// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TravelInsurance {
    address public owner;
    uint256 public policyIdCounter;

    enum PolicyStatus { Active, Claimed, Expired }

    struct Policy {
        address policyHolder;
        string flightNumber;
        uint256 flightTimestamp; // Departure time (UNIX)
        uint256 premium;
        uint256 payoutAmount;
        PolicyStatus status;
    }

    mapping(uint256 => Policy) public policies;
    mapping(address => uint256[]) public userPolicies;

    event PolicyPurchased(uint256 policyId, address user, string flightNumber);
    event PayoutClaimed(uint256 policyId, address user, uint256 amount);
    event PolicyExpired(uint256 policyId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function purchasePolicy(string memory _flightNumber, uint256 _flightTimestamp) external payable {
        require(msg.value > 0, "Premium required");

        uint256 payoutAmount = msg.value * 2; // 2x payout on delay/cancel

        policies[policyIdCounter] = Policy({
            policyHolder: msg.sender,
            flightNumber: _flightNumber,
            flightTimestamp: _flightTimestamp,
            premium: msg.value,
            payoutAmount: payoutAmount,
            status: PolicyStatus.Active
        });

        userPolicies[msg.sender].push(policyIdCounter);

        emit PolicyPurchased(policyIdCounter, msg.sender, _flightNumber);
        policyIdCounter++;
    }

    // Called by oracle (or admin) if flight is delayed or canceled
    function triggerPayout(uint256 _policyId) external onlyOwner {
        Policy storage policy = policies[_policyId];
        require(policy.status == PolicyStatus.Active, "Not claimable");

        policy.status = PolicyStatus.Claimed;
        payable(policy.policyHolder).transfer(policy.payoutAmount);

        emit PayoutClaimed(_policyId, policy.policyHolder, policy.payoutAmount);
    }

    // Called manually to expire unused policies after flight time passes
    function expirePolicy(uint256 _policyId) external {
        Policy storage policy = policies[_policyId];
        require(block.timestamp > policy.flightTimestamp + 6 hours, "Too early");
        require(policy.status == PolicyStatus.Active, "Already processed");

        policy.status = PolicyStatus.Expired;
        emit PolicyExpired(_policyId);
    }

    function getUserPolicies(address _user) external view returns (uint256[] memory) {
        return userPolicies[_user];
    }

    // Owner can withdraw unused funds (e.g., expired policies)
    function withdraw(uint256 amount) external onlyOwner {
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}
