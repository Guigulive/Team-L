## 硅谷live以太坊智能合约 第四课作业
这里是同学提交作业的目录

### 第四课：课后作业
- 将第三课完成的payroll.sol程序导入truffle工程
- 在test文件夹中，写出对如下两个函数的单元测试：
- function addEmployee(address employeeId, uint salary) onlyOwner
- function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)
- 思考一下我们如何能覆盖所有的测试路径，包括函数异常的捕捉
- (加分题,选作）
- 写出对以下函数的基于solidity或javascript的单元测试 function getPaid() employeeExist(msg.sender)
- Hint：思考如何对timestamp进行修改，是否需要对所测试的合约进行修改来达到测试的目的？

### 我的作业
导入truffle工程成功，完成两个函数的单元测试，通过结果可见testResult.png
其中，由于removeEmployee需要实现支付，所有加入了addFund()函数的测试
所有测试情况分别为：
1. function addEmployee(address employeeId, uint salary) onlyOwner
- Owner可以成功添加新employee
- 非Owner不可以添加新employee
- Owner不可以添加已存在的employee
- Owner不可以添加address为0的employee

2. function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)
- 成功给contract添加fund
- 非Owner不可以删除employee
- Owner不可以删除不存在的employee
- Owner可以成功删除已存在的employee
