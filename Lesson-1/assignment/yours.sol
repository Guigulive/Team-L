/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    //初始构造
    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        //限制权限，发行者才可更改
        require(msg.sender == owner);
        //结清上一个用户的薪水
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 100 wei;
        lastPayday = now;
    }
    //payable对于存钱必须写
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
        //限制雇员才可以领薪水
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        //注意和assert的区别
        require(nextPayday < now);

        lastPayday = nextPayday;
        //付钱操作要在最后提高安全
        employee.transfer(salary);
    }
}
