/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract AdvancedPayroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        makeUpOldSalary();
        
        employee = e;
        salary = s * 1 ether;
    }
    
    function updateEmployeeAddr(address e) {
        require(msg.sender == owner);

        makeUpOldSalary();
        
        employee = e;
    }
    
    function updateEmployeeSalary(uint s) {
        require(msg.sender == owner);

        makeUpOldSalary();
        
        salary = s * 1 ether;
    }
    
    function makeUpOldSalary(){
		// 补发之前的工资，把lastPayday的更新放到transfer之前，防止攻击
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            lastPayday = now;
            employee.transfer(payment);
        } else {
			// 上次地址为空时，直接重置工资时间
			lastPayday = now;
		}
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
		// 增加判断
        if (!hasEnoughFund()){
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
