// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CrowdFunding {
  
    struct Campaign {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool ended;
    }

    
    Campaign[] public campaigns;

    event CampaignCreated(uint campaignId, string title, uint goal, uint deadline);
    event DonationReceived(uint campaignId, address donor, uint amount);
    event CampaignEnded(uint campaignId, uint amountRaised);


    modifier campaignNotEnded(uint _campaignId) {
        require(block.timestamp < campaigns[_campaignId].deadline, "Campaign has ended");
        require(!campaigns[_campaignId].ended, "Campaign funds already transferred");
        _;
    }


    modifier validGoal(uint _goal) {
        require(_goal > 0, "Goal must be greater than zero");
        _;
    }


    function createCampaign(
        string memory _title,
        string memory _description,
        address payable _benefactor,
        uint _goal,
        uint _duration
    ) public validGoal(_goal) {
        uint deadline = block.timestamp + _duration;
        campaigns.push(Campaign({
            title: _title,
            description: _description,
            benefactor: _benefactor,
            goal: _goal,
            deadline: deadline,
            amountRaised: 0,
            ended: false
        }));
        emit CampaignCreated(campaigns.length - 1, _title, _goal, deadline);
    }

 
    function donateToCampaign(uint _campaignId) public payable campaignNotEnded(_campaignId) {
        require(msg.value > 0, "Donation amount must be greater than zero");

        Campaign storage campaign = campaigns[_campaignId];
        campaign.amountRaised += msg.value;

        emit DonationReceived(_campaignId, msg.sender, msg.value);
    }


    function endCampaign(uint _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];


        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(!campaign.ended, "Campaign already ended");

        campaign.ended = true;
        campaign.benefactor.transfer(campaign.amountRaised);

        emit CampaignEnded(_campaignId, campaign.amountRaised);
    }


    receive() external payable {
        revert("Direct payments not allowed");
    }
}
