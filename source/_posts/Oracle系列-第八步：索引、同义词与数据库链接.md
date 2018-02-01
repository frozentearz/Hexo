---
title: Oracle系列-第八步：索引、同义词与数据库链接
date: 2017-10-28 02:44:03
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/black-and-white-image-of-laptop-book-and-headphones.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

#### 索引
>索引 (`INDEX`) 是为了加快数据的查找而创建的数据库对象，特别是对大表，索引可以有效地提高查找速度，也可以保证数据的惟一性

创建索引一般要掌握以下原则：  
>只有较大的表才有必要建立索引，表的记录应该大于50条，查询数据小于总行数的2%～4%。  
>虽然可以为表创建多个索引，但是无助于查询的索引不但不会提高效率，还会增加系统开销。  
>因为当执行 DML 操作时，索引也要跟着更新，这时索引可能会降低系统的性能。

创建索引：
```SQL
CREATE INDEX 索引名 ON 表名(列名);
```

删除索引：
```SQL
DROP INDEX 索引名；
```
---

#### 同义词
>同义词 ( `SYNONYM` ) 是为模式对象起的别名，可以为表、视图、序列、过程、函数和包等数据库模式对象创建同义词。


创建私有同义词：
```SQL
CREATE SYNONYM BOOK FOR 图书;
```

创建公有同义词(先要获得创建公有同义词的权限)：
```SQL
CREATE PUBLIC SYNONYM BOOK FOR SCOTT.图书;
```

删除同义词：
```
DROP SYNONYM 同义词名;
```
---

#### 数据库链接
>数据库链接(DATABASE LINK)是在分布式环境下，为了访问远程数据库而创建的数据通信链路。

格式：  
```SQL
CREATE DATABASE LINK [链接名] CONNECT TO [账户] IDENTIFIED BY [口令] USING [服务名];
```
数据库链接一旦建立并测试成功，就可以使用 `表名@数据库链接名` 来访问远程用户的表。

---
