pragma solidity ^0.4.14;
// lesson 1 test
contract Payroll {
    
    address employee = 0x0;
    address owner;
    uint salary = 1 ether;
    uint lastPayday = now;
    uint payDuration = 10 seconds;
    
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    
    function payLastEmployee() private{
        if (employee != 0x0 && salary != 0 && hasEnoughFund()){
            uint payment = salary * ((now - lastPayday)/payDuration);
            employee.transfer(payment);    
        }
    }
    
    function setEmployee(address e){
        if (owner != msg.sender){
            revert();
        }else{
            // if employee not is 0x0, first pay for last employee, then set new employee
            payLastEmployee();
            employee = e;
            lastPayday = now;
        }
    }
    
    function setSalary(uint s){
        if (owner != msg.sender || s <= 0){
            revert();
        }else{
            // if employee not is 0x0, first pay for last employee, then set new employee
            payLastEmployee();
            salary = s * 1 ether;
            lastPayday = now;
        }
    }
    
    function calculateRunway() returns (uint){
        if (salary <= 0){
            revert();
        }
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    
    function getPaid(){
        
        if (employee == 0x0){
            revert();
        }
        
        if (employee != msg.sender){
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        
        if (nextPayday > now){
            revert();
        }
        
        if (hasEnoughFund() == false){
            revert();
        }
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}