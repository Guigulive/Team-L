pragma solidity ^0.4.14;

contract Payroll {
    address owner;
    uint  payDuration = 10 seconds;
    uint lastPayday;
    uint salary;
    address employee;

    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function getPaid() {
        require(msg.sender != employee || !hasEnoughFund());
        uint nextPayday = lastPayday + payDuration;
		require(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}

