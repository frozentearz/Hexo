---
title: Oracle系列-第九步：PL*SQL 编程
date: 2017-10-28 23:44:03
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/computer-with-landscape-on-screen-and-mobile-phone-on-wooden-table.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

#### PL/sql

###### 块结构和基本语法要求
块中各部分的作用解释如下：
- DECLARE：声明部分标志。
- BEGIN：可执行部分标志。
- EXCEPTION：异常处理部分标志。
- END：程序结束标志。
---

###### 输出
第一种形式：
```SQL
DBMS_OUTPUT.PUT(字符串表达式);
```

第二种形式：
```SQL
DBMS_OUTPUT.PUT_LINE(字符串表达式);
```

第三种形式：
```SQL
DBMS_OUTPUT.NEW_LINE;
```
---

###### 变量赋值  
第一种形式：
```SQL
SELECT [列名1], [列名2],[...] INTO [变量1], [变量2],[...] FROM [表名] WHERE [条件];
```
第二种形式：
```SQL
[变量名]:=[值]
```

例：查询雇员编号为7788的雇员姓名和工资。
```SQL
SET SERVEROUTPUT ON
DECLARE--定义部分标识
    v_name VARCHAR2(10);	--定义字符串变量v_name
    v_sal NUMBER(5);	    --定义数值变量v_sal
BEGIN			                --可执行部分标识
    SELECT ename, sal INTO v_name, v_sal
        FROM emp
        WHERE empno=7788;  --在程序中插入的SQL语句
    DBMS_OUTPUT.PUT_LINE('7788号雇员是：'||v_name||'，工资为：'||to_char(v_sal)); --输出雇员名和工资
END;
```
---

###### 结合变量的定义和使用（即全局变量）
>该变量是在整个 `SQL*Plus` 环境下有效的变量，在退出 `SQL*Plus` 之前始终有效，所以可以使用该变量在不同的程序之间传递信息。结合变量不是由程序定义的，而是使用系统命令 `VARIABLE` 定义的。

例：定义并使用结合变量  
输入和执行下列命令，定义结合变量g_ename：
```SQL
VARIABLE g_ename VARCHAR2(100);
```

输入和执行下列程序：
```SQL
SET SERVEROUTPUT ON
BEGIN
    :g_ename:=:g_ename|| 'Hello~';			 --在程序中使用结合变量
    DBMS_OUTPUT.PUT_LINE(:g_ename);      --输出结合变量的值
END;
```
---

###### 记录变量的定义
> 可以根据表或视图的一个记录中的所有字段定义变量，称为记录变量。  
> 记录变量包含若干个字段，在结构上同表的一个记录相同，定义方法是在表名后跟`%ROWTYPE`。  
> 记录变量的字段名就是表的字段名，数据类型也一致。

如： `v_name emp.ename%TYPE;`

---

#### 结构语句

###### IF语句
- IF-THEN-END IF形式
```SQL
IF [条件] then
    [语句集];
END IF;
```

- IF-THEN-ELSE-END IF形式
```SQL
IF [条件] then
    [语句集1];
ElSE
    [语句集2];
END IF;
```

- IF-THEN-ELSIF-ELSE-END IF形式
```SQL
IF [条件1] THEN
    [语句集1];
ELSIF [条件2] THEN
    [语句集2];
ELSIF [条件3] THEN
    [语句集3];
    [...];
ELSE
    [语句集n];
END IF;
```
---

###### CASE 语句
- 基本 CASE 结构
```SQL
CASE [变量或表达式]
    When [值1] then [结果1];
    When [值2] then [结果2];
    When [值3] then [结果3];
    [...];
    ELSE [结果n];
END CASE;
```

- 搜索 CASE 结构
```SQL
CASE
    When [条件1] then [结果1];
    When [条件2] then [结果2];
    When [条件3] then [结果3];
    [...];
    ELSE [结果n];
END CASE;
```
---

###### 循环
- 基本 LOOP 循环
```SQL
loop
    [语句集];
exit when [条件]
    [语句集];
end loop;
```

- FOR LOOP 循环  
FOR 循环是固定次数循环，格式如下：
```SQL
FOR [控制变量] in [REVERSE] [下限..上限] LOOP
    [语句集];
END LOOP;
```
注：循环控制变量是隐含定义的，不需要声明。
>下限和上限用于指明循环次数。  
>正常情况下循环控制变量的取值由下限到上限递增  
>`REVERSE`关键字表示循环控制变量的取值由上限到下限递减。

- WHILE LOOP 循环
```SQL
while [条件] loop
    [语句集];
end loop;
```
---
