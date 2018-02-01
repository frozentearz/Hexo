---
title: Oracle系列-第五步：增删改、序列与事务
date: 2017-10-23 12:07:19
tags: [Oracle,笔记]
categories: Oracle
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/monitor-laptop-computer.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

### 增删改
- 增
```SQL
insert into [表名] [(列名)] values [值];
```
- 删:
```SQL
delete from [表名] where [条件]  --删除表
truncate table [表名] --清空表
```
- 改:
```SQL
update 表名 set [列名1=值1], [列名2=值2],... where [条件]
```
---

### 复制数据
- 通过一条查询语句创建一个新表(要求目标表不存在)  
```SQL
CREATE TABLE manager AS SELECT empno,ename,sal FROM emp WHERE job='MANAGER';
```
- 通过一条查询语句复制数据(要求目标表必须已建好)
```SQL
INSERT INTO manager SELECT empno, ename, sal FROM emp WHERE	job = 'CLERK';
```
---

### 序列

#### 创建序列
如：
创建从2000起始，增量为1 的序列abc：  
```SQL
CREATE SEQUENCE abc INCREMENT BY 1 START WITH 2000
    MAXVALUE 99999 CYCLE NOCACHE;
```
#### 使用序列
   - 序列名.nextval: 代表下一个值  
   - 序列名.currval: 代表当前值  
如：
```SQL
INSERT INTO manager VALUES(abc.nextval,'小王',2500);
INSERT INTO manager VALUES(abc.nextval,'小赵',2800);
```
---

### 事务
>两次连续成功的 **COMMIT** 或 **ROLLBACK** 之间的操作，称为一个事务。在一个事务内，数据的修改一起提交或撤销，如果发生故障或系统错误，整个事务也会自动撤销

PS: *数据库事务处理可分为隐式和显式两种。显式事务操作通过命令实现，隐式事务由系统自动完成提交或撤销(回退)工作，无需用户的干预。*

- 隐式提交的情况包括：

当用户正常退 ***SQLPlus*** 或执行 ***CREATE、DROP、GRANT、REVOKE*** 等命令时会发生事务的自动提交。

- 显示事务:  

| COMMIT | 数据库事务提交，将变化写入数据库 |
|:--|
| **ROLLBACK** | **数据库事务回退，撤销对数据的修改** |
| **SAVEPOIN**T | **创建保存点，用于事务的阶段回退** |
