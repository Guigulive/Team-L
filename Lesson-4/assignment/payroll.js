var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  it("Test addEmployee()", function(){
    return Payroll.deployed().then(function(instance){
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1],1,{from: accounts[0]});
    }).then(function(){
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(res){
        assert.equal(res[0],accounts[1], "Error happened addEmployee()!");
    });
  });

  it("Test removeEmployee()",function(){
    return Payroll.deployed().then(function(instance){
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[2],1,{from: accounts[0]});
    }).then(function(){
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(res){
      assert.equal(res[0], accounts[2], "Error happened at addEmployee(accounts[2])!");
      return payrollInstance.removeEmployee(accounts[2],{from:accounts[0]});
    }).then(function(){
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(res){
      assert.equal(res[0],"0x0000000000000000000000000000000000000000", "Error happened at removeEmployee()!");
    })
  });
});