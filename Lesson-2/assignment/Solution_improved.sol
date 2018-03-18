pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    address private thisAddress = this;
    uint private constant payDuration = 10 seconds;
    
    address private owner;
    Employee[] employees;
    
    uint totalSalary;
    
    function Payroll() public {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0) {
            employee.id.transfer((now-employee.lastPayday)*employee.salary/payDuration);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if(employeeId == employees[i].id) {
                return (employees[i], i);
            }
        }
    }
    
    function getEmployeeNumber() view returns (uint) {
        return employees.length;
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[idx].salary;
        
        delete employees[idx];
        employees[idx] = employees[employees.length-1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeId, uint s) public {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        totalSalary += s * 1 ether;
        employees[idx].salary = s * 1 ether;
        employees[idx].lastPayday = now;
    }
    
    function addFund() payable public returns (uint)  {
        return thisAddress.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return thisAddress.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public{
        var (employee, idx) = _findEmployee(msg.sender);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}