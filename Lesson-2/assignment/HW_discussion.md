# 第二课
## Q1: 每次加入一个员工后调用`calculateRunway`这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

`calculateRunway` 这个函数的gas消耗如下：

| employee address |  transaction cost  |  excution cost  |
| ---------------- |  ----------------  |  -------------  |
| 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c | 23203 | 1931 |
| 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db | 23984 | 2712 |
| 0x583031d1113ad414f02576bd6afabfb302140225 | 24765 | 3493 |
| 0xdd870fa1b7c4700f2bd7f44238821c26f7392148 | 25546 | 4274 |
| 0x9204614a80776af4254bb952e664453aa865d465 | 26327 | 5055 |
| 0x1138ac13089c81eec5143671e176bc67c24ad2bc | 27108 | 5836 |
| 0x1a1c6d3fd95ff828f7a5dac49117c199ed6fd792 | 27889 | 6617 |
| 0xdeb1d8567cdfed449fefc37d4c32c56355eb9c1e | 28670 | 7398 |
| 0x6b6b26075f06c229e394dc3cbe0c4838b15c8c1e | 29451 | 8179 | 
| 0x6141576dd13464db8907d2afe82c2989dfdbb3b9 | 30232 | 8960 |

主要原因是因为每次计算`totalSalary`这个数值的时候需要做一个`for loop`。所以Gas随着员工数量增加。


## Q2: 如何优化calculateRunway这个函数来减少gas的消耗？


把`totalSalary`变成一个全局变量，然后在修改员工的时候顺带修改。改进版本如下：

| employee address |  transaction cost  |  excution cost  |
| ---------------- |  ----------------  |  -------------  |
| 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c | 22361 | 1089 |
| 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db | 22361 | 1089 |
| 0x583031d1113ad414f02576bd6afabfb302140225 | 22361 | 1089 |
| 0xdd870fa1b7c4700f2bd7f44238821c26f7392148 | 22361 | 1089 |
| 0x9204614a80776af4254bb952e664453aa865d465 | 22361 | 1089 |
| 0x1138ac13089c81eec5143671e176bc67c24ad2bc | 22361 | 1089 |
| 0x1a1c6d3fd95ff828f7a5dac49117c199ed6fd792 | 22361 | 1089 |
| 0xdeb1d8567cdfed449fefc37d4c32c56355eb9c1e | 22361 | 1089 |
| 0x6b6b26075f06c229e394dc3cbe0c4838b15c8c1e | 22361 | 1089 |
| 0x6141576dd13464db8907d2afe82c2989dfdbb3b9 | 22361 | 1089 |

