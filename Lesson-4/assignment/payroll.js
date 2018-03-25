var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  var payroll;
  var owner = accounts[0];
    it("addEmployee is succeed...", function() {
      let employeeId = accounts[1];
        return Payroll.deployed().then(function(instance) {
          payroll = instance;
          // 调用函数addEmployee，参数为(address employeeId, uint salary)          
          return payroll.addEmployee(employeeId,2,{from: owner});     
        }).then(function() { 
          let employee = payroll.employees.call(employeeId);
          return employee;
        }).then(function(employee) {
          // 抛出异常，参数为（实际值，预期值，错误的提示信息）
          assert.equal(employee[0], employeeId, "address is not correct.");
          // web3.toWei：把以太坊单位(包含代币单位)转为wei
          assert.equal(employee[1], web3.toWei(2), "salary is not correct.");
        });
      });

    it("removeEmployee is succeed...", function() {
        let employeeId = accounts[2];
        return Payroll.deployed().then(function(instance) {
          payroll = instance;
          return payroll.addEmployee(employeeId,2,{from: owner});                   
        }).then(function() { 
          return payroll.removeEmployee(employeeId,{from: owner}); 
        }).then(function() { 
            let employee=payroll.employees.call(employeeId);
            return employee;
        }).then(function(employee) {
          assert.equal(employee[0], 0x0, "removeEmployee is not correct.");
          assert.equal(employee[1], web3.toWei(0), "removesalary is not correct.");
        });
      });  
  });