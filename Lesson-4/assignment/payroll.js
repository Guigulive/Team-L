var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  var payrollInstance;
  var EmployeeIdx0 = 1;
  var EmployeeIdx1 = 2;
  var EmployeeIdx2 = 3;
  var EmployeeIdx3 = 4;
  var testSalary0 = 1;
  var testSalary1 = 2;
  var testSalary2 = 3;
  var testSalary3 = 4;

  it("Employee can be added only by owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[EmployeeIdx0], testSalary0, {from: accounts[1]})
    }).then(function() {
      assert.fail("Wrong account to add an employee")
    }).catch(function(err) {
      console.log(err);
    })
  });

  it("Employee added successfully by checking total salary", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      payrollInstance.addEmployee(accounts[EmployeeIdx0], testSalary0, {from: accounts[0]})
      payrollInstance.addEmployee(accounts[EmployeeIdx1], testSalary1, {from: accounts[0]})
      payrollInstance.addEmployee(accounts[EmployeeIdx2], testSalary2, {from: accounts[0]})
    }).then(function() {
      return payrollInstance.total();
    }).then(function(total) {
      assert.equal(total.toNumber(), web3.toWei(testSalary0 + testSalary1 + testSalary2), "Wrong total salary.")
    })
  });

  it("Employee can be removed only by owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[EmployeeIdx0], {from: accounts[1]})
    }).then(function() {
      assert.fail("Wrong account to remove an employee.")
    }).catch(function(err) {
      console.log(err);
    })
  });

  it("Employee removed successfully by checking total salary", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[EmployeeIdx2], {from: accounts[0]})
    }).then(function() {
      return payrollInstance.total()
    }).then(function(total) {
      assert.equal(total.toNumber(), web3.toWei(testSalary0 + testSalary1), "Wrong total salary.")
    })
  });

  it("An existing employee can call getPaid successfully.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.getPaid({from: accounts[EmployeeIdx2]})
    }).then(function (result) {
      assert(true, "getPaid success.")
    })
  });

  it("An non-existing employee can not call getPaid successfully.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      payrollInstance.getPaid({from: accounts[EmployeeIdx3]})
    }).then(function (result) {
      assert.fail("getPaid failed.")
    }).catch(function(err) {
      console.log(err);
    })
  });

});
