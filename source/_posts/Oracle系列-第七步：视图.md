---
title: Oracle系列-第七步：视图
date: 2017-10-26 00:25:02
tags: [Oracle,笔记]
categories: Oracle
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/notebook-person-man-laptops.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

### 视图  

- 视图的概念  
>视图不同于表，视图本身不包含任何数据。而视图只是一种定义，对应一个查询语句。视图的数据都来自于某些表，这些表被称为基表。    视图可以在表能够使用的任何地方使用，但在对视图的操作上同表相比有些限制，特别是插入和修改操作。对视图的操作将传递到基表，所以在表上定义的约束条件和触发器在视图上将同样起作用。
---

- 视图的创建
格式：
```SQL
create [or replace] view [视图名]
as
[select 语句];
```
例：创建图书作者视图：
```SQL
CREATE VIEW 图书作者(书名, 作者) AS SELECT 图书名称, 作者 FROM 图书;
```
查询视图全部内容  
```SQL
SELECT * FROM 图书作者;
```
查询部分视图：
```SQL
SELECT 作者 FROM 图书作者;
```
删除视图：
```SQL
DROP VIEW 清华图书;
```
---

- 创建只读视图
创建只读视图要用 `WITH READ ONLY` 选项。  
例：创建 `emp` 表的经理视图：
```SQL
CREATE OR REPLACE VIEW manager
    AS SELECT * FROM emp WHERE job= 'MANAGER'
    WITH READ ONLY;
```
---

- 使用 `WITH CHECK OPTION` 选项  
使用该选项，可以对视图的插入或更新进行限制，即该数据必须满足视图定义中的子查询中的WHERE条件，否则不允许插入或更新。  
例：
```SQL
CREATE OR REPLACE VIEW 清华图书
    AS SELECT * FROM 图书 WHERE 出版社编号= '01'
    WITH CHECK OPTION;
```
注：插入数据时，由于带了 `with check option` 的选项，则只能插入出版社编为'01'的数据
---


- 来自基表的限制  
*除了以上的限制，基表本身的限制和约束也必须要考虑。如果生成子查询的语句是一个分组查询，或查询中出现计算列，这时显然不能对表进行插入。  
另外，主键和 NOT NULL 列如果没有出现在视图的子查询中，也不能对视图进行插入。在视图中插入的数据，也必须满足基表的约束条件。*
---

- 视图的查看  
`USER_VIEWS` 字典中包含了视图的定义。  
`USER_UPDATABLE_COLUMNS` 字典包含了哪些列可以更新、插入、删除。  
`USER_OBJECTS` 字典中包含了用户的对象。  
可以通过 `DESCRIBE` 命令查看字典的其他列信息。  
例：查看用户拥有的视图：
```SQL
SELECT object_name FROM user_objects WHERE object_type='VIEW';
```
