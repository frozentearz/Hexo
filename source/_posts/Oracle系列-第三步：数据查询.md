---
title: Oracle系列-第三步：数据查询
date: 2017-09-19 17:04:49
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/work-hand-tabletop.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---
### 基础查询
#### 查询格式
```SQL
select [列名] from [表名]
    where [查询条件]
    group by [分组列]
    having [分组后条件]
    order by [排序列]
```

---

#### 简单查询
如：查询部门为 10 的雇员。  
输入并执行查询：  
```SQL
SELECT * FROM emp WHERE deptno=10;
```
---

#### 行号
每个表都有一个虚列 **ROWNUM**，它用来显示结果中记录的行号。我们在查询中也可以显示这个列。  
如：显示EMP表的行号。  
输入并执行查询：  
```SQL
SELECT rownum,ename FROM emp;
```

---

#### 查询时进行计算
- 显示雇员工资上浮20%的结果。  
输入并执行查询:   
```SQL
SELECT ename,sal,sal*(1+20/100) FROM emp;
```

- 显示每一个雇员的总收入(工资+奖金)		
```SQL
update emp set comm = 0 where comm is null;  -- 将工资为 null 的改为 0
select ename,sal+comm as 总收入 from emp;
```

---

#### 使用别名
在查询中使用列别名。  
输入并执行：  
```SQL
SELECT ename AS 名称, sal 工资 FROM emp;
```
>PS：建议省略 **AS**

---

#### 在列别名上使用双引号
PS: 当你的别名为关键字或别名中有特殊符号时需要加双引号  
输入并执行查询：  
```SQL
SELECT ename AS "select", sal*12+5000 AS "年度工资(加年终奖)" FROM emp;
```
---

#### 连接运算符
连接运算符是双竖线 **“||”** 。通过连接运算可以将两个字符串连接在一起。  
如：  
```SQL
SELECT ename||job AS "雇员和职务表" FROM emp;
--‘5’ + 5 结果为 10
--‘5’ || 5 结果为 '55'
```        
---

#### 查询结果的排序

- **ASC** 表示升序 (可省略)
- **Desc** 表示降序(不可省略)

###### 升序排序
查询雇员姓名和工资，并按工资从小到大排序。  
输入并执行查询：  
```SQL
SELECT ename, sal FROM emp ORDER BY sal;
```

###### 降序排序
查询雇员姓名和雇佣日期，并按雇佣日期排序，后雇佣的先显示。  
输入并执行查询：  
```SQL
SELECT ename, hiredate FROM emp ORDER BY hiredate DESC;
```
---

#### 多列排序
查询雇员信息，先按部门从小到大排序，再按雇佣时间的先后排序。  
输入并执行查询：  
```SQL
SELECT ename, deptno, hiredate FROM emp ORDER BY deptno, hiredate;
```
---

#### 消除重复行
如果在显示结果中存在重复行，可以使用的关键字 **DISTINCT** 消除重复显示。  
如：使用 **distinct** 消除重复行显示。  
输入并执行查询：  
```SQL
SELECT DISTINCT job FROM emp;
```
---

### 条件查询

#### 模糊查询

##### BETWEEN: 在某某之间
如：显示工资在 1000～2000 之间的雇员信息。  
输入并执行查询：  
```SQL
SELECT * FROM emp WHERE sal BETWEEN 1000 AND 2000;
```

---

##### IN: 在某某之内
如：显示职务为 *SALESMAN，CLERK* 和 *MANAGER* 的雇员信息。  
输入并执行查询：  
```SQL
    SELECT * FROM emp WHERE job IN ('SALESMAN', 'CLERK', 'MANAGER');
```

##### LIKE: 与通配符合用
<small>**通配符**：</small>
- %：代表 0 个或任意个字符
- \_：代表 1 个字符

如：  
1. 显示姓名以 “S” 开头的雇员信息。  
输入并执行查询：  
```SQL
SELECT * FROM emp WHERE ename LIKE 'S%';
```
2. 显示姓名第二个字符为 “A” 的雇员信息。  
执行查询：  
```SQL
SELECT * FROM emp WHERE ename LIKE '_A%';
```
---

#### 空值查询
>空：is null  
>非空：is not null  

如：查询奖金为空的雇员信息  
```SQL
select * from emp where comm is null;
```
---

### 联合查询

#### 相等连接（内连接）

##### 常规模式
- 先列出要显示的列
- 列出查询的表
- 列出多表相连条件（主外键）  
```SQL
select ename, job, sal, comm, emp.deptno, dname
    from emp, dept
    where emp.deptno = dept.deptno
```

>注意：如果两个表有同名列，那么前面必须接表名 如：emp.deptno. 如果不是同名字段则表名可以省略

---

##### Inner join 模式:
```SQL
select ename, job, sal, comm, emp.deptno, dname
    from emp inner join dept
    on emp.deptno = dept.deptno
```

---

##### 三表或三表以上的写法
```SQL
select [字段1], [字段2], [...]
    from [表1], [表2], [...]
    where [表1.外键] = [表2.主键]  and [表1.外键] = [表3.主键] and [...]
```
>注意：两个表有一个条件 ，三个表有两个条件 ，四个表有三个条件 以此类推

---

#### 不等连接(外连接)
>拿一个表作为另一表的查询条件或范围  

如：显示雇员名称，工资和所属工资等级。  
执行以下查询：
```SQL
SELECT e.ename, e.sal, s.grade
    FROM emp e, salgrade s
    WHERE e.sal BETWEEN s.losal AND s.hisal
```

>左外连接即在内连接的基础上，左边表中有但右边表中没有的记录也以 null 的形式显示出来，右外连接则反之

##### Way A

- 右外连接
```SQL
select ename,d.deptno,dname
    from emp e, dept d
    where e.deptno(+) = d.deptno;
```

- 左外连接
```SQL
select ename,d.deptno,dname
    from emp e, dept d
    where d.deptno = e.deptno(+);
```

##### Way B
```SQL
select ename, d.deptno, dname
    from emp e right join dept d
    on e.deptno = d.deptno;
```
---

#### 自连接
>自连接就是一个表，同本身进行连接。对于自连接可以想像存在两个相同的表(表和表的副本)，可以通过不同的别名区别两个相同的表（其它就是内连接）。

显示雇员名称和雇员的经理名称。  
执行以下查询：
```SQL
SELECT worker.ename || ' 的经理是 ' || manager.ename AS 雇员经理
    FROM emp worker, emp manager
    WHERE worker.mgr = manager.empno;
```
---

### 分组查询
如：按职务统计工资总和。  
执行以下查询：
```SQL
SELECT job, SUM(sal) FROM emp
    GROUP BY job;
```
---

- **多列分组**  
按部门和职务分组统计工资总和。  
```SQL
SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY deptno, job;
```
---

- **HAVING**  
>HAVING 从句过滤分组后的结果，它只能出现在 GROUP BY 从句之后，而 WHERE 从句要出现在 GROUP BY 从句之前。  

 统计各部门的最高工资，排除最高工资小于3000的部门。  
执行以下查询：
```SQL
SELECT deptno, max(sal) FROM emp
    GROUP BY deptno
    HAVING max(sal)>=3000;
```
---

- **分组统计结果排序**  
>可以使用ORDER BY从句对统计的结果进行排序，ORDER BY从句要出现在语句的最后。  

 如：按职务统计工资总和并排序。  
执行以下查询：
```SQL
SELECT job 职务, SUM(sal) 工资总和
    FROM emp
    GROUP BY job
    ORDER BY SUM(sal);
```
---

- **组函数的嵌套使用**  
如：求各部门平均工资的最高值。  
执行以下查询：
```SQL
SELECT max(avg(sal)) FROM emp
    GROUP BY deptno;
```
---

### 子查询  
>通过把一个查询的结果作为另一个查询的一部分,子查询一般出现在 SELECT 语句的 WHERE 子句中，Oracle 也支持在 FROM 或 HAVING 子句中出现子查询。

子查询比主查询先执行，结果作为主查询的条件，在书写上要用圆括号扩起来，并放在比较运算符的右侧。  

---

##### 单行子查询
如：查询比SCOTT工资高的雇员名字和工资。  
执行以下查询：  
```SQL
SELECT ename, sal FROM emp WHERE sal > (
    SELECT sal FROM emp WHERE empno = 7788
);
```

---

##### 多行子查询
>如果子查询返回多行的结果，则我们称它为多行子查询。多行子查询要使用不同的比较运算符号，它们是 **IN、ANY** 和 **ALL。**  

如：查询工资低于任意一个 *CLERK* 的工资的雇员信息。  
执行以下查询：
```SQL
SELECT empno, ename, job, sal FROM emp WHERE sal < ANY (
    SELECT sal FROM emp WHERE job = 'CLERK'
) AND job <> 'CLERK';
```

如：查询工资比所有的“SALESMAN”都高的雇员的编号、名字和工资。  
执行以下查询：
```SQL
SELECT empno, ename, sal FROM emp WHERE sal > ALL(
    SELECT sal FROM emp WHERE job= 'SALESMAN'
);
```

如：查询部门20中职务同部门10的雇员一样的雇员信息。  
执行以下查询：
```SQL
SELECT empno, ename, job FROM emp WHERE job IN (
    SELECT job FROM emp WHERE deptno=10
) AND deptno =20;
```
---

##### 多列子查询
>如果子查询返回多列，则对应的比较条件中也应该出现多列，这种查询称为多列子查询。以下是多列子查询的训练实例。

如： 查询职务和部门与SCOTT相同的雇员的信息。  
执行以下查询：
```SQL
SELECT empno, ename, sal FROM emp WHERE (job,deptno) = (
    SELECT job, deptno FROM emp WHERE empno = 7788
);
```
---

##### 在FROM从句中使用子查询
>在FROM从句中也可以使用子查询，在原理上这与在WHERE条件中使用子查询类似。有的时候我们可能要求从雇员表中按照雇员出现的位置来检索雇员，很容易想到的是使用rownum虚列。

如：查询雇员表中排在第6～9位置上的雇员。  
执行以下查询：
```SQL
SELECT ename, sal FROM (
    SELECT rownum as num, ename, sal FROM emp WHERE rownum <= 9
) WHERE num >= 6;
```
---
