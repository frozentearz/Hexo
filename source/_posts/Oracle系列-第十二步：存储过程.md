---
title: Oracle系列-第十二步：存储过程
date: 2018-1-31 20:17:10
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/man-working-on-laptop-in-office.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---


#### 存储过程
###### 创建和删除存储过程
格式：  
```SQL
CREATE [OR REPLACE] PROCEDURE 存储过程名[(参数[IN|OUT|IN OUT] 数据类型...)]
	{AS|IS}
		[说明部分]   --定义需要使用的临时变量
	BEGIN
		语句集;
		[EXCEPTION]
		    [错误处理部分]
	END [过程名];
```
删除：  
```SQL
drop procedure [存储过程名];
```
---

###### 调用存储过程
- 方法一
```SQL
EXECUTE 模式名.存储过程名[(参数...)];
-- (适用于命今行窗口及sql窗口)
```
- 方法二：
```SQL
BEGIN
    模式名.存储过程名[(参数...)];
END;
-- (适用于sql窗口)
```
例：  
编写显示雇员信息的存储过程 EMP_LIST ，并引用 EMP_COUNT 存储过程(无参存储过程)。  
```SQL
CREATE OR REPLACE PROCEDURE EMP_LIST
AS
    CURSOR emp_cursor IS SELECT empno,ename FROM emp;
BEGIN
    FOR Emp_record IN emp_cursor LOOP
      DBMS_OUTPUT.PUT_LINE(Emp_record.empno||Emp_record.ename);
    END LOOP;
    EMP_COUNT;
END;
```
调用：
```SQL
begin
    EMP_LIST;
end;
```


###### 参数传递
- 输入参数:   
```SQL
[参数名] IN [数据类型] DEFAULT [值];
```
例：  
编写给雇员增加工资的存储过程 CHANGE_SALARY，通过 IN 类型的参数传递要增加工资的雇员编号和增加的工资额。  
```SQL
CREATE OR REPLACE PROCEDURE CHANGE_SALARY(P_EMPNO IN NUMBER DEFAULT 7788,P_RAISE NUMBER DEFAULT 10)  
--形参P_EMPNO及P_RAISE
AS
    V_ENAME VARCHAR2(10);
    V_SAL NUMBER(5);
BEGIN
    SELECT ENAME, SAL INTO V_ENAME, V_SAL FROM EMP WHERE EMPNO = P_EMPNO;
    UPDATE EMP SET SAL = SAL + P_RAISE WHERE EMPNO = P_EMPNO;
        DBMS_OUTPUT.PUT_LINE('雇员'||V_ENAME||'的工资被改为'||TO_CHAR(V_SAL+P_RAISE));
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('发生错误，修改失败！');
    ROLLBACK;
    --如果出了异常则撤消
END;
```
调用：  
```SQL
begin
    CHANGE_SALARY(7788, 80)
end;
```

- 输出参数:
```SQL
[参数名] OUT [数据类型] DEFAULT [值];
```
例：  
统计雇员的人数  
```SQL
REATE OR REPLACE PROCEDURE EMP_COUNT(P_TOTAL OUT NUMBER)   
--P_TOTAL为输出参数
AS
BEGIN
    SELECT COUNT(*) INTO P_TOTAL FROM EMP;
END;
```
调用：  
```SQL
DECLARE
    V_EMPCOUNT NUMBER;
    --定义变量接收过程求出的结果
BEGIN
    EMP_COUNT(V_EMPCOUNT);
    DBMS_OUTPUT.PUT_LINE('雇员总人数为：'||V_EMPCOUNT);
END;
```
- 输入输出参数：  
```SQL
[参数名] IN OUT [数据类型] DEFAULT [值];
```
例：  
使用IN OUT类型的参数，给电话号码增加区码。  
```SQL
CREATE OR REPLACE PROCEDURE ADD_REGION(P_HPONE_NUM IN OUT VARCHAR2)
AS
BEGIN
   P_HPONE_NUM:='024-'||P_HPONE_NUM;
END;
```
调用:  
```SQL
DECLARE
    V_PHONE_NUM VARCHAR2(15);
BEGIN
    V_PHONE_NUM:='26731092';
    ADD_REGION(V_PHONE_NUM);
    DBMS_OUTPUT.PUT_LINE('新的电话号码：'||V_PHONE_NUM);
END;
```
