---
title: Oracle系列-第六步：表操作与约束
date: 2017-10-24 17:00:53
tags: [Oracle,笔记]
categories: Oracle
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/table-pen-technology.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

### 表操作
#### 常规建表
格式：
```SQL
create table 表名 (
    [列名1] [类型] [约束],
    [列名2] [类型] [约束],
    [...]
);
```
如：创建出版社表。  
输入并执行以下命令：  
```SQL
CREATE TABLE 出版社(
    编号 VARCHAR2(2),
    出版社名称 VARCHAR2(30),
    地址 VARCHAR2(30),
    联系电话 VARCHAR2(20)
);
CREATE TABLE 图书(
    图书编号 VARCHAR2(5),
    图书名称 VARCHAR2(30),
    出版社编号 VARCHAR2(2),
    作者 VARCHAR2(10),
    出版日期 DATE,
    数量 NUMBER(3),
    单价 NUMBER(7,2)
);
```
---

#### 通过子查询建表
1. 完全复制图书表到“图书1”  
输入并执行以下命令：
```SQL
CREATE TABLE 图书1 AS SELECT * FROM 图书;
```

2. 创建新的图书表“图书2”，只包含书名和单价  
输入并执行以下命令：
```SQL
CREATE TABLE 图书2(书名, 单价) AS SELECT 图书名称, 单价 FROM 图书;
```

3. 创建新的图书表“图书3”，只包含书名和单价，不复制内容  
输入并执行以下命令：
```SQL
CREATE TABLE 图书3(书名, 单价) AS SELECT 图书名称, 单价 FROM 图书 WHERE 1 = 2;
```
---

#### 表的其他操作
- 删除表
```SQL
drop table 表名;
```

- 重命名表
```SQL
RENAME 表名 TO 新表名;
```  

- 查看表  
可以通过对数据字典 `USER_OBJECTS` 的查询，显示当前模式用户的所有表。  
如： 显示当前用户的所有表。
```SQL
SELECT object_name FROM user_objects WHERE object_type='TABLE';
```

- 修改表  
 - 增加新列  
如： 为“出版社”增加一列“电子邮件”：
```SQL
ALTER TABLE 出版社 ADD 电子邮件 VARCHAR2(30) CHECK(电子邮件 LIKE '%@%');
```
 - 修改列  
修改列定义有以下一些特点：  
   - 列的宽度可以增加或减小，在表的列没有数据或数据为 NUL L时才能减小宽度。  
   - 在表的列没有数据或数据为 NULL 时才能改变数据类型，CHAR 和 VARCHAR2 之间可以随意转换。  
   - 只有当列的值非空时，才能增加约束条件 NOT NULL 。  
   - 修改列的默认值，只影响以后插入的数据。如：修改 “出版社” 表 “电子邮件” 列的宽度为 40。  
```SQL
ALTER TABLE 出版社 MODIFY 电子邮件 VARCHAR2(40);
```

  - 删除列  
如：删除“出版社”表的“电子邮件”列。
```SQL
ALTER TABLE 出版社 DROP COLUMN 电子邮件;
```
---

#### 分区表
>在某些场合会使用非常大的表，比如人口信息统计表。如果一个表很大，就会降低查询的速度，并增加管理的难度。一旦发生磁盘损坏，可能整个表的数据就会丢失，恢复比较困难。根据这一情况，可以创建分区表，把一个大表分成几个区(小段)，对数据的操作和管理都可以针对分区进行，这样就可以提高数据库的运行效率。分区可以存在于不同的表空间上，提高了数据的可用性。

例：创建和使用分区表。  
    创建按成绩分区的考生表，共分为3个区：
```SQL
CREATE TABLE 考生 (
	  考号 VARCHAR2(5),
	  姓名 VARCHAR2(30),
	  成绩 NUMBER(3)
)
PARTITION BY RANGE(成绩) (
    PARTITION A VALUES LESS THAN (300)
    TABLESPACE USERS,
    PARTITION B VALUES LESS THAN (500)
    TABLESPACE USERS,
    PARTITION C VALUES LESS THAN (MAXVALUE)
    TABLESPACE USERS
);
```

例：检查A区中的考生：
```SQL
SELECT * FROM 考生 PARTITION(A);
```

例：检查全部的考生：
```SQL
SELECT * FROM 考生;
```
---

### 约束
#### 添加表的约束
| 中文 | 代码 | 缩写 |
|:------------------|
| 主键 | primary key | PK  |
| 唯一 | unique | UQ  |
| 默认值 | default | DF  |
| 检查约束 | check | CK  |
| 外键约束 | foreign key | FK  |
---

###### 方法一：建表的同时添加约束  
如：
```SQL
create table stuinfo
(
    sno int primary key not null,             --主键
    sname varchar2(10) unique not null,       --唯一
    sex char(2) default '男' check(sex='男' or sex = '女') not null,   --默认及检查
    saddress varchar2(50) not null,
    phone char(11),
    email varchar2(50)
);
create table stumarks
(
    marksId int,
    sno int references stuinfo(sno) not null,     --外键
    score number(5,1),
    examDate date default sysdate
);
```
---

###### 方法二:建表完成后，再添加约束  
如:（之前已建好了出版社表及图书表）  
- 主键约束
```SQL
alter table 出版社 add constraint PK_编号
    primary key (编号);
```

- 唯一约束
```SQL
alter table 出版社 add constraint UQ_地址
    unique (地址);
```

- 检查约束
```SQL
alter table 出版社 add constraint CK_联系电话
    check (联系电话 like '1%');
```

- 默认值
```SQL
alter table 出版社 modify 地址 default '湘潭';
```

- 外键约束
```SQL
alter table 图书 add constraint FK_图书编号
    foreign key (图书编号) references 出版社(编号)
```

- 外键约束
```SQL
alter table 图书 add constraint FK_图书编号
    foreign key (图书编号) references 出版社(编号)
```
---

#### 查看约束条件
数据字典 `USER_CONSTRAINTS` 中包含了当前模式用户的约束条件信息。  
其中，`CONSTRAINTS_TYPE` 显示的约束类型为：

- C：CHECK约束。  

- P：PRIMARY KEY约束。  

- U：UNIQUE约束。  

- R：FOREIGN KEY约束。  

其他信息可根据需要进行查询显示，可用 `DESCRIBE` 命令查看 `USER_CONSTRAINTS` 的结构。  
如: 检查表的约束信息：  
```SQL
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = '图书';
```
---

#### 删除约束条件
```SQL
ALTER TABLE 表名 DROP CONSTRAINT 约束名;
```
---
