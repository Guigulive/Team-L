pragma solidity ^0.4.14;

contract Payroll {
    // 指定老板的地址,只有老板有权限调修改员工地址
    address employer = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint  payDuration = 10 seconds;
    uint lastPayday = now;
    // 地址到工资的映射
    mapping (address => uint) salaries;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway(address employee) returns (uint) {
        return this.balance / salaries[employee];
    }
    
    function hasEnoughFund(address employee) returns (bool) {
        return calculateRunway(employee) > 0;
    }
    
    function setSalary(address employee, uint newSalary) {
        // 操作者不是老板或者设置的工资为0则revert
        if (msg.sender != employer || newSalary == 0) {
            revert();
        }
        salaries[employee] = newSalary;
    }
    
    function getPaid(address employee) {
        // 领工资不是本人或者该地址未被设置过工资则revert
        if(msg.sender != employee || salaries[employee] == 0) {
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if (!hasEnoughFund(employee) || nextPayday > now ) {
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salaries[employee]);
    }
    
}
