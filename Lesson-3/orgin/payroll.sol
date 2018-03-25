// 课堂上的代码
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
    uint totalSalary = 0;          
    mapping(address => Employee) public employees;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0); 
        _;
    }

    modifier employeeNew(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0); 
        _;
    }

    function _partialPaid(Employee employee) private {
        // uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment); 
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        salary = salary.mul(1 ether);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary = totalSalary.add(salary);
        employees[employeeId] = Employee(employeeId, salary, now);
    }

    function changePaymentAddress(address employeeId) onlyOwner employeeNew(employeeId) {
        employees[employeeId] = Employee(employeeId, salary, now);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);       
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        // 相当于重置为初始值，因为mapping的key在找不到时value返回它的初始值
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        // 返回的索引是指向storage的可更改数据
        var employee = employees[employeeId];
        _partialPaid(employee);   
        uint backupSalary = employee.salary;        
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.sub(backupSalary).add(employee.salary); 
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return this.calculateRunway() > 0;
    }

    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
      
    
	function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
	    uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);        
    }
}
