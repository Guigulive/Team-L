/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    //状态变量 
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address => Employee) public employees;
    
    //初始默认为0
    uint totalSalary;

    //Ownable已经实现
    /*function Payroll() {
        owner = msg.sender;
        //totalSalary = 0;
    }
    
    modifier onlyOwner {
         require(msg.sender == owner);
         _;
    }*/
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    //新增加的modifier项目
    modifier employeeNew(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment); 
    }
    

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNew(employeeId){
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary, now);
        
        totalSalary = totalSalary.add(salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        //相当于重置为初始值，因为mapping的key在找不到时value返回它的初始值

    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        //返回的索引是指向storage的可更改数据
        
        _partialPaid(employee);
        uint backupSalary = employee.salary;
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;

        totalSalary = totalSalary.sub(backupSalary).add(employee.salary);
    }
    
    function changePaymentAddress(address newEmployeeId) employeeExist(msg.sender) employeeNew(newEmployeeId){
        var employee = employees[msg.sender];
        employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, employee.lastPayday);
        delete employees[msg.sender];
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        //assert(totalSalary > 0);
        
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        //employees[msg.sender].lastPayday = nextPayday;
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
