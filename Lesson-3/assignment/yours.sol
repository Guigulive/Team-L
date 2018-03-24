/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll {

	struct Employee {
		address id;
		uint salary;
		uint lastPayday;
	}

	address owner;
	uint constant payDuration = 10 seconds;
	uint totalSalary;
	mapping (address => Employee) employees;
	address[] employeesId;

	function Payroll() {
		owner = msg.sender;
		totalSalary = 0;
	}
	
	modifier is_owner {
	    require(msg.sender == owner);
	    _;
	}

	function _partialPaid(Employee employee) private {
		uint partialAmount = employee.salary * (now - employee.lastPayday) / payDuration;
		employee.id.transfer(partialAmount);
	}

	function updateEmployee(address _empId, uint _empSalary) is_owner {

		var employee = employees[_empId];
		assert(employee.id != 0x0);

		_partialPaid(employee);
//		employees[_empId].lastPayday = now;
		uint prevSalary = employees[_empId].salary;
		employees[_empId] = Employee(_empId, _empSalary * 1 ether, now);
		totalSalary = totalSalary - prevSalary + employees[_empId].salary;
	}

	function changePaymentAddress(address _empOldId, address _empNewId) is_owner {

		assert(_empOldId != _empNewId);

		var employee = employees[_empOldId];
		assert(employee.id != 0x0);
		_partialPaid(employee);
		employees[_empNewId] = Employee(_empNewId, employee.salary, now);
        delete employees[_empOldId];
/*        
		for (uint i = 0; i < employeesId.length -1; i++ ) {
			if (employeesId[i] == _empOldId) {
				employeesId[i] = _empNewId;
				break;
			}
		}
*/
	}

	function addEmployee(address _empId, uint _empSalary) is_owner {
		var employee = employees[_empId];
		assert(employee.id == 0x0);

        uint weiSalary = _empSalary * 1 ether;
		employees[_empId] = Employee(_empId, weiSalary, now);
		totalSalary += weiSalary;
		
//		employeesId.push(_empId) - 1;
	}

	function removeEmployee(address _empId) is_owner {

		var employee = employees[_empId];
		assert(employee.id != 0x0);
		_partialPaid(employee);
		delete employees[_empId];

/*
		for (uint i = 0; i < employeesId.length -1; i++ ) {
			if (employeesId[i] == _empId) {
				employeesId[i] = employeesId[employeesId.length -1];
				employeesId.length -=1;
				break;
			}
		}
*/		
	}

	function addFund() payable returns (uint) {
		return this.balance;
	}

	function calculateRunway() returns (uint) {
		assert(totalSalary > 0);
		return this.balance / totalSalary;
	}

	function hasEnoughFund() returns (bool) {
		return calculateRunway() > 0;
	}

	function getPaid() {
		var employee = employees[msg.sender];

		assert(employee.id != 0x0);
		uint nextPayday = employee.lastPayday + payDuration;
		assert(nextPayday < now);
		employees[msg.sender] =  Employee(msg.sender, employee.salary, nextPayday);
		employees[msg.sender].id.transfer(employee.salary);

	}
}

