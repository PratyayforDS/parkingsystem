// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract parkingsystem
{
    address payable [] public driver;
    address public manager;
    mapping(address => uint) public payment;
    mapping(address => uint) public starttime;     // timestamp of inserting the car into garage.
    mapping(address => uint) public endtime;       // timestamp of leaving with the car from the garage.
    mapping(address => uint) public diff;          // differnce in starttime and end time.
    mapping(address => uint) public timeofparking; // total time of parking. 
    mapping(address => uint) public price;         // total parking fee of the user.
    mapping(address => uint) public price_;        // total parking fee of the user.(Just to use in another function.)
    mapping(address => uint) public amount;        // total amount of money to return to a driver.
    uint cashback;             // integer for total total amount returned to a user.
    uint time;           // integer for total parking time of a user.
    uint cost;           // integer for total parking fee of a user.

    constructor ()
    {
        manager=msg.sender;
    }
    modifier owner() {
        require(msg.sender == manager, "You are not the manager");
        _;
    }

    receive() external payable {
        require(msg.value >= 1000 gwei);
        payment[msg.sender]=msg.value;
        driver.push(payable(msg.sender));
        starttime[msg.sender]=block.timestamp;
        
    }

    // function to check how much profit is gained till now.
    function getBalance() public view returns(uint256) {
        require(msg.sender == manager, "You are not the manager");
        return  address(this).balance;
    }

    // function to return the remaining payment after the parking charge;
    function withdraw(address)public payable  {
        payable(msg.sender).transfer(Refund());
        cashback = Refund();
        time = TimeCalculate();
        cost = PriceCalculate();
    }

     // function to see how much is the parking cost, how much did he get as a refund,and the time he used.
     // only shows the last transaction.
    function ViewLatestRefund() public view returns(uint, uint ,uint){
        return (cost,cashback,time);
    }

    // FUnction to calculate the amount of price to retuen to the user.
    function Refund()public  returns(uint) {
        price_[msg.sender]=PriceCalculate();
        require(payment[msg.sender]>=price_[msg.sender],"You have not paid enough money to be this late.");
            amount[msg.sender]=payment[msg.sender]-price_[msg.sender];
            return amount[msg.sender];   
    }

    // Parking charge is 100 wei per second.
    // Function to calculate the total parking price of a user from total parking time.
    function PriceCalculate()public returns (uint256){
        timeofparking[msg.sender]=TimeCalculate();
        price[msg.sender]=(100*timeofparking[msg.sender]);
        return price[msg.sender];
    }

    // Function to calculate the total parking time of a user.
    function TimeCalculate() public returns(uint256){
        endtime[msg.sender]=block.timestamp;
        diff[msg.sender]=(endtime[msg.sender]-starttime[msg.sender]);
        return diff[msg.sender];
        }      
}  
