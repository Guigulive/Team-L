pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Lesson3 is Ownable{
    uint constant payDuration = 10 seconds;
    mapping(address => Employee) public employees;
    uint public totalSalary;
    
    struct Employee{
            address id;
            uint salary;
            uint lastPayday;
    }    
    modifier employeeExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }    
    modifier checkTotalSalary(address employeeId,uint newSalary){
        var employee=employees[employeeId];
         totalSalary=SafeMath.sub(totalSalary,employee.salary);
         totalSalary=SafeMath.add(totalSalary,newSalary*1 ether);
        _;
    }    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }   
    function addEmployee(address employeeId,uint salary) onlyOwner checkTotalSalary(employeeId,salary){
        var employee=employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId]=Employee(employeeId,salary*1 ether,now);
    }   
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) checkTotalSalary(employeeId,0){
        var employee=employees[employeeId];
        _partialPaid(employee);        
        delete employees[employeeId];
    }
    function updateEmployee(address employeeId, uint salary)  onlyOwner employeeExist(employeeId)  checkTotalSalary(employeeId,salary){
        var employee=employees[employeeId];
        _partialPaid(employee);        
        employees[employeeId].salary=salary * 1 ether;
        employees[employeeId].lastPayday=now;
    } 
    function addFund() payable returns (uint) {
        return this.balance;
    }  
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }  
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    } 
    function getPaid() employeeExist(msg.sender){
        var employee=employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }    
    function changePaymentAddress(address employeeId,address newemployeeId) onlyOwner employeeExist(employeeId){
        var employee=employees[employeeId];
        employees[newemployeeId]=Employee(newemployeeId,employee.salary,employee.lastPayday);
        delete employees[employeeId];
    }  
}