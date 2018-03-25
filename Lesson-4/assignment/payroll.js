var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  
    it("addEmployee should be success.", function() {
        return Payroll.deployed().then(function(instance) {
          payrollInstance = instance;
          payrollInstance.addEmployee(accounts[1],2) ;     
        }).then(function() { 
          let employee=payrollInstance.employees.call(accounts[1]);
          return employee;
        }).then(function(employee) {
          assert.equal(employee[0], accounts[1], "address is not correct.");
          assert.equal(employee[1], web3.toWei(2), "salary is not correct.");
        });
      });

    it("removeEmployee should be success.", function() {
        return Payroll.deployed().then(function(instance) {
          payrollInstance = instance;
          payrollInstance.addEmployee(accounts[2],2);           
        }).then(function() { 
            payrollInstance.addFund({value: 100}); 
        }).then(function() { 
            payrollInstance.removeEmployee(accounts[2]); 
        }).then(function() { 
            let employee=payrollInstance.employees.call(accounts[2]);
            return employee;
        }).then(function(employee) {
          assert.equal(employee[0], 0x0, "removeEmployee is not correct.");
          assert.equal(employee[1], web3.toWei(0), "removesalary is not correct.");
        });
      });  
  });