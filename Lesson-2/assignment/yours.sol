pragma solidity ^0.4.14;

contract payroll {

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
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment); 
    }

    function _findEmployee(address employeeId) private returns (Employee) {
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return employees[i];
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary, now));
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var employee = _findEmployee(employeeId);
        assert(employee.id != 0x0);    
        _partialPaid(employee);         
        delete employee;
        employee = employees[employees.length - 1];
        employees.length -= 1;
        return;      
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = _findEmployee(employeeId);
        assert(employee.id != 0x0);        
        _partialPaid(employee);         
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        return;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for(uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary * 1 ether;
        }        
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return this.calculateRunway() > 0;
    }
      
    
	function getPaid() {
        var employee = _findEmployee(msg.sender);
        assert(employee.id != 0x0); 

	    uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

         employee.lastPayday = nextPayday;
         employee.id.transfer(employee.salary);        
    }
}
