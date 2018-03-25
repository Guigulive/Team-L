var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("...should match employee id with account 10.", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      assert(PayrollInstance !== undefined, "Payroll is deployed");

      return PayrollInstance.addEmployee(accounts[9], 2, {from: accounts[0]});
    }).then(function() {
      return PayrollInstance.employees(accounts[9]);
    }).then(function(storedData) {
      assert.equal(storedData[0], accounts[9], "The employee id and accounts 10 was not matched.");
    });
  });

  it("...should return no more employee.", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      assert(PayrollInstance !== undefined, "Payroll is deployed");

      return PayrollInstance.removeEmployee(accounts[9], {from: accounts[0]});
    }).then(function() {
      return PayrollInstance.employees(accounts[9]);
    }).then(function(storedData) {
      assert(storedData[0], undefined, "The employee id should undefined.");
    });
  });

});
