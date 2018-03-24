var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {


  it("test addEmployee", function(){
    return Payroll.deployed().then(function(instance){
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1],1,{from: accounts[0]});
    }).then(function(){
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(res){
        assert.equal(res[0],accounts[1], "addEmployee is not correct!");
    });
  });

  it("test removeEmployee",function(){
    return Payroll.deployed().then(function(instance){
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[2],1,{from: accounts[0]});
    }).then(function(){
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(res){
      assert.equal(res[0], accounts[2], "addEmployee : accounts[2], is not correct!");
      return payrollInstance.removeEmployee(accounts[2],{from:accounts[0]});
    }).then(function(){
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(res){
      assert.equal(res[0],"0x0000000000000000000000000000000000000000", "removeEmployee is not correct!");
    })
  });
});
