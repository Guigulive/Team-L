pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;             // *

    address owner;
    mapping(address => Employee)employees;

    function Payroll () payable {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment); 
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;          // *
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);    
        _partialPaid(employee);       
        totalSalary -= employees[employeeId].salary * 1 ether;          // *  
        delete employees[employeeId];
        return;      
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);        
        _partialPaid(employee);   
        totalSalary -= employees[employeeId].salary * 1 ether;          // *        
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary * 1 ether;          // *  
        employees[employeeId].lastPayday = now;        
        return;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        // uint totalSalary = 0;
        // for(uint i = 0; i < employees.length; i++) {
        //     totalSalary += employees[i].salary;
        // }        
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return this.calculateRunway() > 0;
    }
      
    
	function getPaid() {
        var employee = employees[msg.sender];
        assert(employee.id != 0x0); 

	    uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
         employee.id.transfer(employee.salary);        
    }
}