var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("test on add employee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], accounts[1], "address was not saved correctly.");
      assert.equal(employee[1], web3.toWei(1), "salary was not saved correctly.");
    });
  });

  it("test on remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(function(){
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], "0x0000000000000000000000000000000000000000", "address was not removed correctly.");
      assert.notEqual(employee[1], web3.toWei(1), "salary was not removed correctly.");
    });
  });
});