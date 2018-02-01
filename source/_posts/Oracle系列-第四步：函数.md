---
title: Oracle系列-第四步：函数
date: 2017-10-22 04:18:59
tags: [Oracle,笔记]
categories: Oracle
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/black-and-white-image-of-laptop-computer-keyboard-mobile-phone-and-headphones.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

#### 函数
##### 数学函数
| 函数 | 功能 | 实例 | 结果                    |
|:--------------------------------------------|
| abs() | 求绝对值函数 | abs(-5) | 5           |
| sqrt() | 求平方根函数 | sqrt(2) | 1.41421356 |
| power() | 求幂函数 | power(2,3) | 8         |

如：  
1. 使用求绝对值函数 `abs`
```SQL
SELECT abs(-5) FROM dual;
```

2. 使用求平方根函数 `sqrt`
```SQL
SELECT sqrt(2) FROM dual;
```

3. 使用 `ceil` 函数  
```SQL
SELECT ceil(2.35) FROM dual;
```

4. 使用 `floor` 函数  
```SQL
SELECT floor(2.35) FROM dual;
```
---

##### 使用四舍五入函数 round()
格式：```round(数字，保留的位数)```
```SQL
SELECT round(45.923,2), round(45.923,0), round(45.923,-1) FROM dual;
```
---

##### 字符型函数
| 函数名   |    功能    |    实例    |     结果                                       |
|:----------------------------------------------------------------------------------|
| ascii | 获得字符的ASCII码 | Ascii('A') | 65                                        |
| chr | 返回与ASCII码相应的字符 | Chr(65) | A                                         |
| lower | 将字符串转换成小写 | lower('SQL Course') | sql course                       |
| upper | 将字符串转换成大写 | upper('SQL Course') | SQL COURSE                       |
| initcap | 将字符串转换成每个单词以大写开头 | initcap('SQL course') | Sql Course      |
| concat | 连接两个字符串 | concat('SQL', ' Course') | SQL Course                    |
| substr | 给出起始位置和长度，返回子字符串 | substr('String',1,3) | Str              |
| length | 求字符串的长度 | length('Wellcom')  | 7                                  |
| trim | 在一个字符串中去除另一个字符串 | trim('S' FROM 'SSMITH') | MITH             |
| replace | 用一个字符串替换另一个字符串中的子字符串 | replace('ABC', 'B', 'D') | ADC |


如：  
1. 如果不知道表的字段内容是大写还是小写，可以转换后比较。  
输入并执行查询：  
```SQL
SELECT empno, ename, deptno
    FROM emp
    WHERE lower(ename) = 'blake';
```

2. 显示名称以“W”开头的雇员，并将名称转换成以大写开头。  
输入并执行查询：
```SQL
SELECT empno,initcap(ename),job
    FROM emp
    WHERE substr(ename,1,1) = 'W';
```

3. 显示雇员名称中包含 “S” 的雇员名称及名称长度。  
输入并执行查询：
```SQL
SELECT empno,ename,length(ename)
    FROM emp
    WHERE instr(ename, 'S', 1, 1)>0;
```
---

##### 日期型函数
> **Oracle** 使用内部数字格式来保存时间和日期，包括世纪、年、月、日、小时、分、秒。缺省日期
格式为 `DD-MON-YY`。**SYSDATE** 是返回系统日期和时间的虚列函数。

如:  
`08-05月-03` 代表 2003 年 5 月 8 日。  

---

##### SYSDATE：返回系统日期和时间的虚列函数。
如：返回系统的当前日期。  
输入并执行查询：
```SQL
SELECT sysdate FROM dual;
```
---

##### 对两个日期相减，得到相隔天数。
通过加小时来增加天数，24 小时为一天，如 12 小时可以写成 12/24 (或 0.5 )。  
如：  
假定当前的系统日期是 2003 年 2 月 6 日，求再过 1000 天的日期。  
输入并执行查询：
```SQL
SELECT sysdate + 1000 AS "NEW DATE" FROM dual;
```

两个日期相减
```SQL
select to_date('1-1月-2000') - to_date('1-8月-1999') from dual;
```
---

##### 其它日期函数
| 函数 | 功能 | 实例 | 结果  |
|:-----------------------------------------------------------------------------------|
| months_between | 返回两个日期间的月份 | months_between ('04-11月-05','11-1月-01') | 57.7741935 |
| add_months | 返回把月份数加到日期上的新日期 | add_months('06-2月-03',1) add_months('06-2月-03',-1) | 06-3月-03 06-1月-03 |
| next_day | 返回指定日期后的星期对应的新日期 | next_day('06-2月-03','星期一') | 10-2月-03 |
| last_day | 返回指定日期所在的月的最后一天 | last_day('06-2月-03') | 28-2月-03 |
| round | 行四舍五入 | round(to_date('13-2月-03'),'YEAR') <br> round(to_date('13-2月-03'),'MONTH') <br> round(to_date('13-2月-03'),'DAY') | 01-1月-03 <br> 01-2月-03 <br> 16-2月-03 |
(按照四舍五入)  
如：  
返回 2003 年 2 月的最后一天。  
输入并执行查询：
```SQL
SELECT last_day('08-2月-03') FROM dual;
```

假定当前的系统日期是 2003 年 2 月 6 日，显示部门 10 雇员的雇佣天数。
输入并执行查询：
```SQL
SELECT ename, round(sysdate-hiredate) DAYS
    FROM emp
    WHERE deptno = 10;
```
---

#### 转换函数

##### 自动类型转换
```SQL
SELECT '12.5'+11 FROM dual;
--结果为：`23.5`
```

```SQL
Select  ‘12.5’||11 from dual;
--结果为：`12.511`
```
---

##### 日期类型转换

###### 日期型转字符型
将日期转换成带时间和星期的字符串并显示。  
执行以下查询：
```SQL
SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS AM DY') FROM dual;
```
将日期显示转换成中文的年月日。  
输入并执行查询：
```SQL
SELECT TO_CHAR(sysdate,'YYYY"年"MM"月"DD"日"') FROM dual;
```
---

###### 字符型转日期型
往 `emp` 表中插入记录
```SQL
insert into emp
    values(8888,'张三','CLERK',7369,to_date('1-1月-2000'),1000,10,10);
insert into emp
    values(8889,'李四','CLERK',7369,to_date('2000-01-01','YYYY-MM-DD'),1000,10,10);
```

---

#### 其他常用函数

##### 空值的转换
>如果对空值NULL不能很好的处理，就会在查询中出现一些问题。在一个空值上进行算术运算的结果都是NULL。  
>
>最典型的例子是，在查询雇员表时，将工资sal字段和津贴字段comm进行相加，如果津贴为空，则相加结果也为空，这样容易引起误解。
>
>使用nvl函数，可以转换NULL为实际值。该函数判断字段的内容，如果不为空，返回原值；为空，则返回给定的值。  

如下3个函数，分别用新内容代替字段的空值：  
1. `nvl(comm, 0)`：用 0 代替空的 Comm 值。
2. `nvl(hiredate, '01-1月-97')`：用 1997 年 1 月 1 日代替空的雇佣日期。
3. `nvl(job, '无')`：用“无”代替空的职务。

使用 `nvl` 函数转换空值。  
执行以下查询：
```SQL
SELECT ename, nvl(job, '无'), nvl(hiredate, '01-1月-97'), nvl(comm, 0)
    FROM emp;
```
---

##### `decode` 函数
>`decode` 函数可以通过比较进行内容的转换，完成的功能相当于分支语句。  
在参数的最后位置上可以存在单独的参数，如果以上比较过程没有找到匹配值，则返回该参数的值，如果不存在该参数，则返回 NULL 。

将职务转换成中文显示。
执行以下查询：
```SQL
SELECT ename, decode(job, 'MANAGER', '经理', 'CLERK','职员', 'SALESMAN','推销员', 'ANALYST','系统分析员','未知')
    FROM emp;
```
---

##### 最大、最小值函数
`greatest` 返回参数列表中的最大值，`least` 返回参数列表中的最小值。  
如果表达式中有 NULL ，则返回 NULL 。
