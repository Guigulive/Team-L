var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  var payrollInstance;
  var testEmployeeId = 1;
  var testAnotherEmpolyee = 3;
  var testWrongOwner = 5;
  var testSalary = 1;

  it("add employee by right owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[testEmployeeId], testSalary, {from: accounts[0]});
    }).then(function() {
      return payrollInstance.employees.call(accounts[testEmployeeId]);
    }).then(function(employee) {
      assert.equal(employee[0], accounts[testEmployeeId], "Address is wrong.");
      assert.equal(employee[1], web3.toWei(testSalary), "Salary is wrong.");
      assert.equal(employee[2].toNumber(), web3.eth.getBlock(web3.eth.blockNumber).timestamp, "LastPayDay is wrong.");
    }).catch(function(err) {
      console.error(err);
    });
  });

  it("can not add employee by other people", function() {
    var hasThrown = true;
    
    return payrollInstance.addEmployee(accounts[testAnotherEmpolyee], testSalary, {from: accounts[testWrongOwner]}
    ).then(function() {
      hasThrown = false;
      assert.fail('Wrong: Other people can add employee.');
    }).catch(function(err) {
      assert.equal(hasThrown, true, "Wrong: Other people can add employee.");
      if (!hasThrown)
        console.wrong(err);
    });
  });

  it("can not add existed employee by owner", function() {
    var hasThrown = true;
    
    return payrollInstance.addEmployee(accounts[testEmployeeId], testSalary, {from: accounts[0]}
    ).then(function() {
      hasThrown = false;
      assert.fail('Wrong: Owner can add existed employee.');
    }).catch(function(err) {
      assert.equal(hasThrown, true, "Wrong: Owner can add existed employee.");
      if (!hasThrown)
        console.wrong(err);
    });
  });

  it("can not add employee with null address by owner", function() {
    var hasThrown = true;
    
    return payrollInstance.addEmployee("0x", testSalary, {from: accounts[0]}
    ).then(function() {
      hasThrown = false;
      assert.fail('Wrong: Owner can add employee with null address.');
    }).catch(function(err) {
      assert.equal(hasThrown, true, "Wrong: Owner can add employee with null address.");
      if (!hasThrown)
        console.wrong(err);
    });
  });

  it("can not remove employee by other people", function() {
    var hasThrown = true;
    
    return payrollInstance.removeEmployee(accounts[testEmployeeId], {from: accounts[testWrongOwner]}
    ).then(function() {
      hasThrown = false;
      assert.fail('Wrong: Other people can remove employee.');
    }).catch(function(err) {
      assert.equal(hasThrown, true, "Wrong: Other people can remove employee.");
      if (!hasThrown)
        console.wrong(err);
    });
  });

  it("can not remove non-existent employee by owner", function() {
    var hasThrown = true;
    
    return payrollInstance.removeEmployee(accounts[testAnotherEmpolyee], {from: accounts[0]}
    ).then(function() {
      hasThrown = false;
      assert.fail('Wrong: Owner can remove non-existent employee.');
    }).catch(function(err) {
      assert.equal(hasThrown, true, "Wrong: Owner can remove non-existent employee.");
      if (!hasThrown)
        console.wrong(err);
    });
  });

  //add fund for testing the remove employee function
  it("add fund by owner", function() {
    var fund = web3.toWei(50, 'ether');
    return payrollInstance.addFund({from:accounts[0], value: fund}
    ).catch(function (err){
      assert.fail("Failed to add fund by owner.");
      console.wrong(err);
    })
  });

  it("remove employee by right owner", function() {
    return payrollInstance.removeEmployee(accounts[testEmployeeId], {from: accounts[0]}
    ).then(function() {
      return payrollInstance.employees.call(accounts[testEmployeeId]);
    }).then(function(employee) {
      assert.equal(employee[0], "0x0000000000000000000000000000000000000000", "Address is wrong.");
      assert.equal(employee[1], 0, "Salary is wrong.");
      assert.equal(employee[2].toNumber(), 0, "LastPayDay is wrong.");
    }).catch(function(err) {
      console.error(err);
    });
  });


});