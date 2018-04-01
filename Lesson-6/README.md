## 硅谷live以太坊智能合约频道官方地址

### 第六课

#### payroll-react

A payroll system developed with React and Solidty for Ethereum Blockchain platform. 

#### Get Started

1. Install dependencies

   ```bash
   $ npm i -g truffle              				// Truffle是最流行的开发框架
   $ npm install -g truffle ethereumjs-testrpc		// 适用开发的客户端
   $ npm install									// 安装包
   ```

2. Install [Metamask](https://metamask.io/),Add first account in testrpc to Metamask by importing private key

3. 运行truffle

   ```bash
   $ testrpc						// 运行(另起terminal)
   $ truffle compile				// 编译
   $ truffle migrate --reset		// 部署
   $ truffle console 				// 交互
   ```

4. 运行前端

   ```bash
   $ npm run start
   ```