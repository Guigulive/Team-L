pragma solidity ^0.4.14;

//完成今天的智能合约添加100ETH到合约中
//- 加入十个员工，每个员工的薪水都是1ETH
//每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
//- 如何优化calculateRunway这个函数来减少gas的消耗？
//提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

//	调用calculateRunway函数的gas记录如下：
//	次数:transaction cost, execution cost 
//	1:22973,1701  
//	2:23754,2482  
//	3:24535,3263
//	4:25316,4044
//	5:26097,4825
//	6:26878,5606
//	7:27659,6387
//	8:28440,7168
//	9:29221,7949
//	10:30002,8730


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
    
    //结算之前的员工
    function _partialPaid(Employee employee) private {
    	uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
    	assert(payment <= this.balance);
    	employee.id.transfer(payment);
    }
    
    //根据员工的address来查找数组的index
    function _findEmployee(address employeeId) private returns (Employee, uint) {
    	for(uint i = 0; i < employees.length; i++){
    		if (employees[i].id == employeeId){
    			return (employees[i], i);
    		}
    	}
    }

    //添加新员工，需要对之前的员工工资结算嘛?
    function addEmployee(address employeeId, uint salary) {
    	require(msg.sender == owner);

    	var (employee, index) = _findEmployee(employeeId);
    	assert(index >= 0);

    	assert(salary > 0);
    	employees.push(Employee(employeeId, salary * 1 ether, now));
    	totalSalary += salary * 1 ether;
    }

    //移除员工,这里需要将移除的员工进行工资清算
    function removeEmployee(address employeeId) {
    	require(msg.sender == owner);

    	var (employee, index) = _findEmployee(employeeId);
    	assert(index >= 0);

    	_partialPaid(employee);
        
        totalSalary -= employee.salary;
    	delete employees[index];
    	employees[index] = employees[employees.length-1];
    	employees.length -= 1;
    	
    }
    
    //修改员工,这里需要将移除的员工进行工资清算
    function updateEmployee(address employeeId, uint salary) {
    	require(msg.sender == owner);
    	var (employee, index) = _findEmployee(employeeId);
    	assert(index >= 0);
    	_partialPaid(employee);
        
        totalSalary -= employee.salary;
        
    	employees[index]=Employee(employeeId, salary * 1 ether, now);
    	
    	totalSalary += salary * 1 ether;
    	
    }
    
    //存钱，不限制必须是owner
    function addFund() payable returns (uint) {
    	return this.balance;
    }
    
    //优化前 计算可以支付的周期
    function calculateRunway_back() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        assert(totalSalary > 0);
        return this.balance / totalSalary;
    }

    //优化后 计算可以支付的周期
    function calculateRunway() returns (uint) {
        require(totalSalary > 0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
    	return calculateRunway() > 0;
    }
    //员工获取工资
    function getPaid() public returns(uint, uint, uint){
    	var (employee, index) = _findEmployee(msg.sender);
    	assert(index >= 0);

    	uint nextPayday =  employees[index].lastPayday + payDuration;
    	assert(nextPayday < now);
    	assert(hasEnoughFund());

    	employees[index].lastPayday = now;
    	employees[index].id.transfer(employees[index].salary);
        return (index, nextPayday, now);
    }
}
