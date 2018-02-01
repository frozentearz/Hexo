---
title: Oracle系列-第二步：建表空间、用户及授权
date: 2017-09-18 17:44:23
tags: [Oracle,笔记]
categories: Oracle
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/notebook-and-ballpoint-with-laptop-in-background.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

#### Oracle常用命令

##### 切换用户  
```SQL
connect [用户名/密码@数据库名]
```  

如:
```SQL
conn scott/tiger@orcl
```

##### 显示当前用户
```SQL
show user
```

##### 显示表的结构
```SQL
describe 表名
```

如：
```SQL
desc scott.emp
```

---

#### 创建表空间
格式：
```SQL
create tablespace [表空间名] datafile ['文件路径'] size [文件大小];
```
如：
```SQL
create tablespace mySpace datafile 'd:\mySpace.dbf' size 10m;
```
删除表空间：
```SQL
drop tablespace myspace;
```

---

#### 创建用户
格式:
```SQL
create user [用户名] identified by [密码] default tablespace [默认表空间名]
```
如：
```SQL
create user user1 identified by user1 default tablespace system
```
删除用户：
```SQL
drop user user1
```

---

#### 给用户授权

##### 方式一：授予角色
- connect  :    登录
- resource:     普通权限，用于操作
- DBA:          管理员权限 （慎用）

如：  
```SQL
grant connect to user1
grant connect, resource to user1
```

##### 方式二：授予单个权限
如：  
- 授予 *user1* 建表的权限
```SQL
grant create table to user1
```
- 授予 *user1* 删表的权限
```SQL
grant drop table to user1
```

##### 方式三：将某个对象的权限授予用户
如：  
- 将 *scott* 用户的emp表的查询权限授予 *user1*:
```SQL
grant select on scott.emp to user1
```
- 将 *scott* 用户的emp表的所有权限授予 *user1*:
```SQL
grant all on scott.emp to user1
```

---

###### 收回权限
回收用户的某项权限
```SQL
revoke [权限] from [用户]
```

- 收回 *user1* 的 **connect** 权限
```SQL
revoke connect from user1
```

- 收回 *user1* 对 **emp** 表的查询权限
```SQL
revoke select on scott.emp from user1
```
---
