/*作业请提交在这个目录下*/
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
    uint totalSalary;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        // employee.lastPayday = now; // rewrite data on calldata, no use?
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i<employees.length; i++){
            if (employees[i].id == employeeId) {
                // Employee storage sEmployee = employees[i];
                // return (sEmployee, i);
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        totalSalary -= employees[index].salary;
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId); // employee in memory
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        // employee.salary = s * 10 ether;
        totalSalary -= employees[index].salary;
        totalSalary += salary;
        
        employees[index].salary = salary * 1 ether;
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
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        // 增加判断
        assert(hasEnoughFund());
        // if (!hasEnoughFund()){
        //     revert();
        // }
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday<now);
        // if(nextPayday > now){
        //     revert();
        // }

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
