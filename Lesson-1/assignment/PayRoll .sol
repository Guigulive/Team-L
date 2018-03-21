pragma solidity ^0.4.14;

contract PayRoll {
    uint constant payDuration = 10 seconds;
    address owner;
    uint salary;
    uint lastPayday;
    address Employee;
    function PayRoll(){
        owner=msg.sender;
    }
    function  addFund() payable returns(uint) {
        return this.balance;
    }
    function calculateRunway() returns(uint){
        return this.balance/salary;
    }
    function hasEnoughFund() returns(bool){
        return calculateRunway() > 0;
    }
    function updateEmployee(address ed,uint sa){
        require(msg.sender==owner);
        if(Employee!=0x0){
            uint payM=salary*(now-lastPayday)/payDuration;
            Employee.transfer(payM);
        }
        salary= sa;
        lastPayday = now;
        Employee = ed;
    }
    function getPaid(address dz){
        require(msg.sender == dz);
        require(msg.sender == Employee);
        uint nextPayDay=lastPayday+payDuration;
        if(nextPayDay>now){
            revert();
        }
        lastPayday=nextPayDay;
        dz.transfer(salary);
    }   
}
