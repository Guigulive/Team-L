## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


随着员工增加，Calculate Runway消耗的Gas也同步增加，原因在于遍历数组的开销增加。解决方案可以定义本地变量记录总工资
First Employee
 transaction cost 	22966 gas 
 execution cost 	1694 gas 

Second Employee:
 transaction cost 	23747 gas 
 execution cost 	2475 gas

Third Employee:
 transaction cost 	24528 gas 
 execution cost 	3256 gas 

Fourth Employee:
 transaction cost 	25309 gas 
 execution cost 	4037 gas

Fifth Employee:
 transaction cost 	26090 gas 
 execution cost 	4818 gas 

Sixth Employee:
 transaction cost 	26871 gas 
 execution cost 	5599 gas

Seventh Employee:
 transaction cost 	27652 gas 
 execution cost 	6380 gas 

Eighth Employee:
 transaction cost 	28433 gas 
 execution cost 	7161 gas

Nineth Employee:
 transaction cost 	29214 gas 
 execution cost 	7942 gas 

Tenth Employee:
 transaction cost 	29995 gas 
 execution cost 	8723 gas 

修改CalculateRunway 函数后，Gas固定不变：
 transaction cost 	22356 gas
 execution cost 	1084 gas



