## 硅谷live以太坊智能合约 第三课作业

- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

* L(O) 	= [O]
* L(A) 	= [A] + MERGE(L(O),[O])
		= [A] + MERGE([O], [O])
		= [A, O]
* L(B)	= [B, O]
* L(C)	= [C, O]

* L(K1)	= [K1] + MERGE(L(A), L(B), [A, B])
		= [K1] + MERGE([A, O], [B, O], [A, B]
		= [K1, A] + MERGE([O], [B, O], [B])
		= [K1, A, B] + MERGE([O], [O])
		= [K1, A, B, O]

* L(K2) = [K2, A, C, O]

* L(Z) 	= [Z] + MERGE(L(K1), L(K2), [K1, K2])
		= [Z] + MERGE([K1, A, B, O], [K2, A, C, O], [K1, K2])
		= [Z, K1] + MERGE([A, B, O], [K2, A, C, O], [K2])
		= [Z, K1, K2] + MERGE([A, B, O], [A, C, O])
		= [Z, K1, K2, A] + MERGE([B, O], [C, O])
		= [Z, K1, K2, A, B] + MERGE([O], [C, O])
		= [Z, K1, K2, A, B, C] + MERGE([O],[O])
		= [Z, K1, K2, A, B, C, O]
		
[参考维基百科](https://en.wikipedia.org/wiki/C3_linearization)