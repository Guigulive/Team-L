pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint partialAmount = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(partialAmount);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=1; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i); 
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (emp, idx) = _findEmployee(employeeId);
        assert(emp.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (emp, idx) = _findEmployee(employeeId);
        assert(emp.id != 0x0);
        employees[idx] = employees[employees.length -1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (emp, idx) = _findEmployee(employeeId);
        assert(emp.id != 0x0);
        _partialPaid(emp);
        employees[idx].id = employeeId;
        employees[idx].salary = salary;
        employees[idx].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid(address employeeId) {
        require(msg.sender == owner);

        var (emp, idx) = _findEmployee(employeeId);
        uint nxtPayday = emp.lastPayday + payDuration;
        assert(nxtPayday < now);

        employees[idx].lastPayday = nxtPayday;
        employees[idx].id.transfer(emp.salary);
    }
}
