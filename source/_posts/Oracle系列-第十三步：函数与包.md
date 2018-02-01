---
title: Oracle系列-第十三步：函数与包
date: 2018-1-31 20:32:49
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/macbook-internet-computers.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---
#### 函数
例：  
创建一个通过雇员编号返回雇员名称的函数 GET_EMP_NAME。  
```SQL
CREATE OR REPLACE FUNCTION GET_EMP_NAME(P_EMPNO NUMBER DEFAULT 7788)
RETURN VARCHAR2
AS
	V_ENAME VARCHAR2(10);
BEGIN
	SELECT ENAME INTO V_ENAME FROM EMP WHERE EMPNO=P_EMPNO;	            
    RETURN(V_ENAME);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('没有该编号雇员！');
	        RETURN (NULL);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('有重复雇员编号！');
	        RETURN (NULL);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('发生其他错误！');
	        RETURN (NULL);
END;
```
调用：  
```SQL
BEGIN
    DBMS_OUTPUT.PUT_LINE('雇员7369的名称是：'|| GET_EMP_NAME(7369));
    DBMS_OUTPUT.PUT_LINE('雇员7839的名称是：'|| GET_EMP_NAME(7839));
END;
```
删除函数格式：  
```SQL
DROP FUNCTION [函数名];
```
---

#### 包

###### 概念
>包是用来存储相关程序结构的对象，它存储于数据字典中。  
包由两个分离的部分组成：包头( PACKAGE ) 和包体 ( PACKAGE BODY )。
- 包头是包的说明部分，是对外的操作接口，对应用是可见的；
- 包体是包的代码和实现部分，对应用来说是不可见的黑盒。

>说明部分可以出现在包的三个不同的部分：出现在包头中的称为公有元素，出现在包体中的称为私有元素，出现在包体的过程(或函数)中的称为局部变量。  
>在包体中出现的过程或函数，如果需要对外公用，就必须在包头中说明，包头中的说明应该和包体中的说明一致。

###### 包的优点：  
>组织过程或函数，解决重名问题，增加了安全性，方便授权，减少了多次访问过程或函数的 I/O 次数等  

###### 创建包和包体  
>包由包头和包体两部分组成，包的创建应该先创建包头部分，然后创建包体部分。  
创建、删除和编译包的权限同创建、删除和编译存储过程的权限相同。

>在 SQL*Plus 环境下，包和包体可以分别编译，也可以一起编译。
- 如果分别编译，则要先编译包头，后编译包体。  
- 如果在一起编译，则包头写在前，包体在后，中间用“/”分隔。  

例：  
创建管理雇员信息的包 EMPLOYE ，它具有从 EMP 表获得雇员信息，修改雇员名称，修改雇员工资和写回 EMP 表的功能。  
```SQL
CREATE OR REPLACE PACKAGE EMPLOYE --包头部分
IS
	PROCEDURE SHOW_DETAIL;
	PROCEDURE GET_EMPLOYE(P_EMPNO NUMBER);
	PROCEDURE SAVE_EMPLOYE;
	PROCEDURE CHANGE_NAME(P_NEWNAME VARCHAR2);
	PROCEDURE CHANGE_SAL(P_NEWSAL NUMBER);
END EMPLOYE;
/
CREATE OR REPLACE PACKAGE BODY EMPLOYE
--包体部分
IS
	EMPLOYE EMP%ROWTYPE;
--变量，以下过程或函数都可以调用

-------------- 显示雇员信息 ---------------
PROCEDURE SHOW_DETAIL
AS
BEGIN
	DBMS_OUTPUT.PUT_LINE(‘----- 雇员信息 -----’);
	DBMS_OUTPUT.PUT_LINE('雇员编号：'||EMPLOYE.EMPNO);
	DBMS_OUTPUT.PUT_LINE('雇员名称：'||EMPLOYE.ENAME);
 	DBMS_OUTPUT.PUT_LINE('雇员职务：'||EMPLOYE.JOB);
 	DBMS_OUTPUT.PUT_LINE('雇员工资：'||EMPLOYE.SAL);
	DBMS_OUTPUT.PUT_LINE('部门编号：'||EMPLOYE.DEPTNO);
END SHOW_DETAIL;

------ 从EMP表取得一个雇员 ------
PROCEDURE GET_EMPLOYE(P_EMPNO NUMBER)
AS
BEGIN
	SELECT * INTO EMPLOYE FROM EMP WHERE 	EMPNO=P_EMPNO;
	DBMS_OUTPUT.PUT_LINE('获取雇员'||EMPLOYE.ENAME||'信息成功');
END GET_EMPLOYE;

------- 保存雇员到EMP表 ---------
PROCEDURE SAVE_EMPLOYE
AS
BEGIN
	UPDATE EMP SET ENAME=EMPLOYE.ENAME, SAL=EMPLOYE.SAL WHERE EMPNO =
EMPLOYE.EMPNO;
	DBMS_OUTPUT.PUT_LINE('雇员信息保存完成！');
END SAVE_EMPLOYE;

------------ 修改雇员名称 ------------
PROCEDURE CHANGE_NAME(P_NEWNAME VARCHAR2)
AS
BEGIN
	EMPLOYE.ENAME:=P_NEWNAME;
	DBMS_OUTPUT.PUT_LINE('修改名称完成！');
END CHANGE_NAME;

------------ 修改雇员工资 ------------
PROCEDURE CHANGE_SAL(P_NEWSAL NUMBER)
AS
BEGIN
    EMPLOYE.SAL:=P_NEWSAL;
    DBMS_OUTPUT.PUT_LINE('修改工资完成！');
END CHANGE_SAL;
END EMPLOYE;
```

调用：  
获取雇员7788的信息:  
```SQL
SET SERVEROUTPUT ON
EXECUTE EMPLOYE.GET_EMPLOYE(7788);
```

显示雇员信息：
```SQL
EXECUTE EMPLOYE.SHOW_DETAIL;
```

修改雇员工资：
```SQL
EXECUTE EMPLOYE.CHANGE_SAL(3800);
```

将修改的雇员信息存入EMP表
```SQL
EXECUTE EMPLOYE.SAVE_EMPLOYE;
```
