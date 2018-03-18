/*作业请提交在这个目录下*/

/*
添加10个员工每次calculateRunway() 后gas的变化记录如下：
- transaction cost : 
22995 gas -> 23776 gas -> 24557 gas -> 25338 gas -> 26119 gas -> 26900 gas -> 27681 gas 
-> 28462 gas -> 29243 gas -> 30024 gas 

- execution cost 	
1723 gas -> 2504 gas -> 3285 gas -> 4066 gas -> 4847 gas -> 5628 gas -> 6409 gas -> 7190 gas
 -> 7971 gas -> 8752 gas 

结论：消耗的gas随着次数均匀增大，因为calculateRunway() 用了for循环语句，随着数组的长度增加，要运算的次数相应增加，消耗的gas必然增多。

改进思路：calculateRunway() 调用for的很多运算是重复消耗的，比如每新加入一个employee，就将之前的salary重新叠加，而之前成员的salary叠加在不更改的情况下一直是固定值，因此我修改为在每次add/remove/update employee时即时对totalSalary进行叠加或修改运算，避免计算冗余。

改进结果：改进后calculateRunway() gas消耗，每次都固定在 transaction cost : 22353 gas， execution cost : 1081 gas 
*/

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
        totalSalary = 0;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment); 
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            } 
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        salary = salary * 1 ether;
        employees.push(Employee(employeeId, salary, now));
        
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        uint backupSalary = employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
                
        /*totalSalary计算放在salary修改之后，避免修改时出现问题导致的数据不准确*/
        totalSalary -= backupSalary;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employees[index]);
        uint backupSalary = employee.salary;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;

        totalSalary = totalSalary - backupSalary + employees[index].salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
       /*for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }*/
        assert(totalSalary > 0);
        
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
