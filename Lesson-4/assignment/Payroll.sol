pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    mapping (address => Employee) public employees;
    uint totalSalary;

    modifier employeeNotExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.salary == 0x0);  
        _; 
    }

    modifier employeeExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employeeId != 0x0);
        _; 
    }
    
    function _partialPaid(address employeeId) private {
        uint payment = employees[employeeId].salary.mul((now.sub(employees[employeeId].lastPayday))).div(payDuration);
        employeeId.transfer(payment);
    }

    function total() public view returns (uint) {
      return totalSalary;
    }

    function changePaymentAddress(address newEmployeeId) public employeeExists(msg.sender) employeeNotExists(newEmployeeId) {
        uint oldSalary = employees[msg.sender].salary;
        delete employees[msg.sender];
        employees[newEmployeeId] = Employee(newEmployeeId, oldSalary, now);
    }
    
    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExists(employeeId) {
        uint salaryInEther = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salaryInEther, now);
        totalSalary = totalSalary.add(salaryInEther);
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExists(employeeId) {
        _partialPaid(employeeId);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExists(employeeId) {
        _partialPaid(employeeId);
        totalSalary = totalSalary.add(salary.mul(1 ether)).sub(employees[employeeId].salary);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function checkEmployee(address employeeId) public view onlyOwner returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() public employeeExists(msg.sender) {
        address id = msg.sender;
        uint nextPayday = employees[id].lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[id].lastPayday = nextPayday;
        id.transfer(employees[id].salary);
    }
}

