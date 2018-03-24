pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    address owner;
    mapping (address => Employee) public employees;
    uint totalSalary;

    modifier employeeExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employeeId != 0x0);  
        _; 
    }
    
    function _partialPaid(address employeeId) private {
        uint payment = employees[employeeId].salary * (now - employees[employeeId].lastPayday) / payDuration;
        employeeId.transfer(payment);
    }

    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) employeeExists(oldEmployeeId) {
        _partialPaid(oldEmployeeId);
        uint oldSalary = employees[oldEmployeeId].salary;
        delete employees[oldEmployeeId];
        employees[newEmployeeId] = Employee(oldSalary, now);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        uint salaryInEther = salary * 1 ether;
        employees[employeeId] = Employee(salaryInEther, now);
        totalSalary = totalSalary.add(salaryInEther);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
        _partialPaid(employeeId);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        _partialPaid(employeeId);
        totalSalary = totalSalary.add(salary.mul(1 ether)).sub(employees[employeeId].salary);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
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

    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() employeeExists(msg.sender) {
        address id = msg.sender;
        uint nextPayday = employees[id].lastPayday + payDuration;
        assert(nextPayday < now);

        employees[id].lastPayday = nextPayday;
        id.transfer(employees[id].salary);
    }
}

