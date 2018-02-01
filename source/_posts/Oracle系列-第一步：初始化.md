---
title: Oracle系列-第一步：初始化
date: 2017-09-17 02:44:03
tags: [Oracle,笔记]
categories: Oracle
toc: true
---

![Oracle notes](http://otdo5q3gt.bkt.clouddn.com/modernism-macbook-keyboard-laptops.jpg)
**Some notes of Learning Oralce.**
<!-- more -->

---

<small style="color:#FF7F50">本笔记使用 *scott* 模式作为示例环境</small>  

1. 登录 *system* 用户

2. 解锁 *scott* 用户

  ```SQL
  alter user scott account unlock;
  ```

3. 修改 *scott* 密码

  ```SQL
  alter user scott identified by tiger;
  ```

---
