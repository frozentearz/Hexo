---
title: Oracle系列-第十一步：异常处理与集合运算
date: 2018-1-31 17:48:20
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/man-working-on-laptop-with-coffee-mug-in-background.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

#### 异常处理与集合运算
错误处理的语法如下：
```SQL
EXCEPTION
  WHEN 错误1[OR 错误2] THEN 语句序列1;
  WHEN 错误3[OR 错误4] THEN 语句序列2;
  ...
  WHEN OTHERS 语句序列n;
END;
```
例：  
```SQL
SET SERVEROUTPUT ON
    DECLARE
        v_name VARCHAR2(10);
    BEGIN
        SELECT	ename  INTO v_name  FROM emp  WHERE	empno = 1234;
	DBMS_OUTPUT.PUT_LINE('该雇员名字为：'|| v_name);
	EXCEPTION
  		WHEN NO_DATA_FOUND THEN	DBMS_OUTPUT.PUT_LINE('编号错误，没有找到相应雇员！');
  		WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('发生其他错误！');
    END;
```
---

#### 集合运算
| 操作 | 描述 |
|:---|---|
| UNION | 并集，合并两个操作的结果，去掉重复的部分 |
| UNION ALL | 并集，合并两个操作的结果，保留重复的部分 |
| MINUS | 差集，从前面的操作结果中去掉与后面操作结果相同的部 |
| INTERSECT | 交集，取两个操作结果中相同的部分 |

如：  
查询部门10和部门20的所有职务。  
```SQL
SELECT job FROM emp WHERE deptno = 10
  UNION SELECT job FROM emp
  WHERE deptno = 20;
```

如：  
查询部门10和20中是否有相同的职务和工资。  
```SQL
SELECT job, sal FROM emp WHERE deptno = 10
  INTERSECT
  SELECT job, sal FROM emp WHERE deptno = 20;
```
如：  
查询只在部门表中出现，但没有在雇员表中出现的部门编号。
```SQL
SELECT deptno FROM dept
  MINUS
  SELECT deptno FROM emp ;
```
---
