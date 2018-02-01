---
title: Oracle系列-第十步：游标
date: 2018-1-31 16:45:45
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/retina-macbook-macbook-computer.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

#### 游标

###### 概念
>游标是 SQL 的一个内存工作区，由系统或用户以变量的形式定义。游标的作用就是用于临时存储从数据库中提取的数据块。在某些情况下，需要把数据从存放在磁盘的表中调到计算机内存中进行处理，最后将处理结果显示出来或最终写回数据库。这样数据处理的速度才会提高，否则频繁的磁盘数据交换会降低效率。

游标有两种类型：显式游标和隐式游标。
>在前述程序中用到的 [SELECT ... INTO ... ] 查询语句，一次只能从数据库中提取一行数据，系统都会使用一个隐式游标。  
>显式游标对应一个返回结果为多行多列的SELECT语句。  
游标一旦打开，数据就从数据库中传送到游标变量中，然后应用程序再从游标变量中分解出需要的数据，并进行处理。

---

###### 隐式游标属性

| 隐式游标的属性 | 返回值类型 | 意义 |
|:--|
| SQL%ROWCOUNT | 整型 | 代表 DML 语句成功执行的数据行数 |
| SQL%FOUND | 布尔型 | 值为 TRUE 代表插入、删除、更新或单行查询操作成功|
| SQL%NOTFOUND | 布尔型 | 与 SQL%FOUND 属性返回值相反 |
| SQL%ISOPEN | 布尔型 | DML 执行过程中为真，结束后为假 |

如：  
使用隐式游标的属性，判断对雇员工资的修改是否成功。  
输入和运行以下程序：
```SQL
SET SERVEROUTPUT ON
BEGIN
UPDATE emp SET sal=sal+100 WHERE empno=1234;
IF SQL%FOUND THEN
DBMS_OUTPUT.PUT_LINE('成功修改雇员工资！');
COMMIT;
ELSEDBMS_OUTPUT.PUT_LINE('修改雇员工资失败！');
END IF;
END;
```
---

###### 显式游标

游标的使用分成以下4个步骤。  
1. 声明游标  
在 DECLEAR 部分按以下格式声明游标:
```SQL
CURSOR [游标名][([参数1] [数据类型]，[参数2] [数据类型]...])]
IS SELECT语句;
```
参数是可选部分，所定义的参数可以出现在SELECT语句的WHERE子句中。  
如果定义了参数，则必须在打开游标时传递相应的实际参数。

2. 打开游标  
在可执行部分，按以下格式打开游标：
```SQL
OPEN [游标名][([实际参数1][，[实际参数2]...])];
```
打开游标时，SELECT语句的查询结果就被传送到了游标工作区。

3. 提取数据  
在可执行部分，按以下格式将游标工作区中的数据取到变量中。  
提取操作必须在打开游标之后进行。
```SQL
FETCH [游标名] INTO [变量名1][，[变量名2]...];
```
或
```SQL
FETCH [游标名] INTO [记录变量];
```
游标打开后有一个指针指向数据区，FETCH语句一次返回指针所指的一行数据，要返回多行需重复执行，可以使用循环语句来实现。  
控制循环可以通过判断游标的属性来进行。
  定义记录变量的方法如下：
```
[变量名] [表名]|[游标名]%ROWTYPE；
```

4. 关闭游标
```SQL
CLOSE [游标名];
```
显式游标打开后，必须显式地关闭。  
游标一旦关闭，游标占用的资源就被释放，游标变成无效，必须重新打开才能使用。  

如：  
用游标提取emp表中7788雇员的名称和职务。  
```SQL
SET SERVEROUTPUT ON
DECLARE
    v_ename VARCHAR2(10);
    v_job VARCHAR2(10);
    CURSOR emp_cursor IS
SELECT ename, job FROM emp WHERE empno = 7788;
BEGIN
    OPEN emp_cursor;
    FETCH emp_cursor INTO v_ename,v_job;
    DBMS_OUTPUT.PUT_LINE(v_ename||','||v_job);
    CLOSE emp_cursor;
END;
```
如：  
用游标提取emp表中7788雇员的姓名、职务和工资。  
```SQL
SET SERVEROUTPUT ON
DECLARE
	CURSOR emp_cursor IS  SELECT ename, job, sal FROM emp WHERE empno = 7788;
	emp_record emp_cursor%ROWTYPE;
	--用游标定义记录变量
BEGIN
	OPEN emp_cursor;
	FETCH emp_cursor INTO emp_record;
	DBMS_OUTPUT.PUT_LINE(emp_record.ename||','|| emp_record.job||','|| emp_record.sal);
	CLOSE emp_cursor;
END;
```

如：  
显示工资最高的前3名雇员的名称和工资。  
```SQL
SET SERVEROUTPUT ON
DECLARE
	V_ename VARCHAR2(10);
	V_sal NUMBER(5);
	CURSOR emp_cursor IS  SELECT ename,sal FROM emp ORDER BY sal DESC;
BEGIN
	 OPEN emp_cursor;
	 FOR I IN 1..3 LOOP
	   FETCH emp_cursor INTO v_ename,v_sal;
     DBMS_OUTPUT.PUT_LINE(v_ename||','||v_sal);
   END LOOP;
   CLOSE emp_cursor;
END;
```
---

###### * 游标循环
- 使用特殊的FOR循环形式显示全部雇员的编号和名称(省略掉定义记录变量、打开游标、提取数据、关闭游标)。  
```SQL
SET SERVEROUTPUT ON
DECLARE
 	CURSOR emp_cursor IS
  SELECT empno, ename FROM emp;
BEGIN
	FOR Emp_record IN emp_cursor LOOP
		 DBMS_OUTPUT.PUT_LINE(Emp_record.empno|| Emp_record.ename);
	END LOOP;
END;
```

- 最简单方式
```SQL
SET SERVEROUTPUT ON
BEGIN	 FOR re IN (SELECT ename FROM EMP)  LOOP
		DBMS_OUTPUT.PUT_LINE(re.ename)
	END LOOP;
END;
```

###### 利用游标属性做循环条件
如：  
使用游标的属性练习。  
```SQL
SET SERVEROUTPUT ON
DECLARE
	 V_ename VARCHAR2(10);
	 CURSOR emp_cursor IS
   SELECT ename FROM emp;
BEGIN	 OPEN emp_cursor;
  IF emp_cursor%ISOPEN THEN
    LOOP
      FETCH emp_cursor INTO v_ename;
      EXIT WHEN emp_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(to_char(emp_cursor%ROWCOUNT)||'-'||v_ename);
    END LOOP;
  ELSE
    DBMS_OUTPUT.PUT_LINE('用户信息：游标没有打开!');
  END IF;
  CLOSE emp_cursor;
END;
```
