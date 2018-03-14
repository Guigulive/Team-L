pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;

    struct Employee {
	  address addr;
	  uint salary;
	  uint payday;
	}

	Employee public employee

    function Payroll() {
        owner = msg.sender;
    }
    

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee.addr != 0x0) {
            uint payment = employee.salary * (now - employee.payday) / payDuration;
            employee.addr.transfer(payment);
        }
        
        employee.addr = e;
        employee.salary = s * 1 ether;
        employee.payday = now;
    }

    function setEmpAddress(address e) returns (address) {
    	require(msg.sender == employee.addr);

    	if ((employee.addr != e) && (e != 0x0)) {
    		employee.addr = e;
    	}

    	return employee.addr;
    }

    function setEmpSalary(address e, uint s) returns (uint) {
    	require(msg.sender == owner);

    	if (employee.addr != 0x0) {
    		uint payment = employee.salary * (now - employee.payday) / payDuration;
    		employee.addr.transfer(payment);
    	}

    	employee.salary = s * 1 ether;
    	return employee.salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / employee.salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee.addr);
        
        uint nextPayday = employee.payday + payDuration;
        assert(nextPayday < now);

        employee.payday = nextPayday;
        employee.addr.transfer(employee.salary);
    }
}
