pragma solidity ^0.4.14;

contract Payroll {
    address owner;
    uint  payDuration = 10 seconds;
    mapping (address => uint) lastPaydays;
    mapping (address => uint) salaries;

    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway(address employee) returns (uint) {
        return this.balance / salaries[employee];
    }
    
    function hasEnoughFund(address employee) returns (bool) {
        return calculateRunway(employee) > 0;
    }
    
    function setSalary(address employee, uint newSalary) {
        require(msg.sender == owner && newSalary > 0);
        salaries[employee] = newSalary;
        lastPaydays[employee] = now;
    }
    
    function getPaid(address employee) {
        // 领工资不是本人或者该地址未被设置过工资则revert
        uint salary = salaries[employee];
        if(msg.sender != employee || salary == 0 || !hasEnoughFund(employee)) {
            revert();
        }
        uint nextPayday = lastPaydays[employee] + payDuration;
        if (nextPayday > now ) {
            revert();
        }
        lastPaydays[employee] = nextPayday;
        employee.transfer(salary);
    }
}
