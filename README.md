***哈工大深圳 数据库系统实验四成果代码***
**项目成果展示**

**网页开始页面：**
![page](img/1.png)

**志愿活动申请页面：**
![page](img/2.png)

**管理员审批活动页面：**
![page](img/3.png)

**活动发布页面：**
![page](img/4.png)

**超级管理员页面：**
![page](img/5.png)


1. **实验环境**

   1.1 **实验所用的操作系统**

   Windows 11 家庭中文版

   1.2 **主要开发工具**

   - 数据库 E-R 图设计：PowerDesigner 16.5
   - 数据库后台管理系统：MySQL Workbench 8.0CE
   - 前后端交互方案：基于 Django 构建的网页展示应用
   - 前后端交互编程语言：Python
   - 前端开发所用的 IDE：PyCharm 2022.2 (Professional Edition)

2. **实验过程**

   2.1 **系统功能**

   2.1.1 **系统设计功能（即设计数据库时所考虑的功能）**

   根据本次实验所设计出的校园志愿者招募平台，绘制出系统的功能层次图：
   ![page](img/func.png)

   - **系统用户管理**

     在平台上，有两种用户类型：普通用户（志愿者）和平台管理员。这两种用户可以执行以下操作：
     
     - 注册：用户可以根据自身的身份进行注册，成为系统的一部分。
     - 登录和登出：用户可以使用已注册的账户登录到系统，同时也可以在不需要时安全登出。
     - 查询个人信息：用户在登录系统后可以查询自己在系统上的个人信息。

   - **系统活动管理**

     平台在首页展示志愿活动的信息，这些信息包括时间、地点、活动要求和活动人数等。无论用户是否登录，都可以查看发布在平台上的志愿活动信息。此外，平台管理员有以下操作权限：

     - 添加活动：管理员可以填写活动名称、时间、地点等活动信息，将新活动发布在首页供用户浏览。
     - 修改活动：管理员可以对现有的活动信息进行修改，并更新展示在首页。
     - 删除活动：管理员可以将活动信息从平台上移除。

     同时，每个活动都有一个状态属性，可以表示活动是否正在报名或已过期。过期的活动会被系统自动关闭从而不可被申请并会被显示为已过期。

   - **活动申请管理**

     普通用户可以执行以下操作：
     
     - 浏览活动信息：用户可以在首页查看所有活动信息，无需登录。
     - 申请参加活动：用户登录后可以申请参加正在报名状态的活动。
     - 查看申请状态：用户可以查看自己已提交的活动申请的审核状态，包括待审核、通过或拒绝。

     平台管理员可以执行以下操作：
     
     - 查看申请人清单：管理员可以查看针对他们发布的活动的申请人清单。
     - 审核申请：管理员可以审核申请人的活动申请，选择通过或拒绝。

   - **系统服务评价（亮点功能，已在功能层次图用*标志）**

     志愿者完成某次志愿活动的服务后，由发布该活动的管理员对志愿者的实际服务情况进行评价。服务评价包括以下内容：
     
     - 录入实际服务小时数：管理员记录该名志愿者在本次活动中的实际服务小时数。
     - 评分志愿者的整体服务表现：管理员对志愿者的整体服务表现进行评分，满分为10分，最低不能低于0分。
     - 撰写评语：管理员为志愿者的本次服务撰写评语。

     完成服务评价后，志愿者可以查询评价结果。同时，志愿者的累计服务时长、平均服务得分等属性也会随之更新。

   - **优秀志愿者展示（亮点功能，已在功能层次图用*标志）**

     - 展示优秀志愿者的信息
     - 调用存储函数选择优秀志愿者

   2.1.2 **系统实现功能（即实际编程时所实现的功能）**

   完成了该校园志愿者招募平台的设计后，实际编程实现了如下功能：

   - **在未登录状态、志愿者登录状态或活动管理员登录状态下均能查看在首页查看全部志愿活动的信息；**
   - **志愿者、活动管理员两种用户进行注册、登录、登出，并查看个人信息；**
   - **活动管理员输入时间、地点、人数、要求等信息，发布新活动；**
   - **志愿者申请参加活动；**
   - **活动管理员查询自己所发布活动的申请人清单，对志愿者所提交的申请进行审核，并通过或拒绝志愿者的申请；**
   - **活动管理员能够修改已经发布的活动的信息、能够删除已经发布的活动。**
   - **志愿者查询申请结果，并能观察到自己提交的申请是待审核、通过还是拒绝状态。（*）**
   - **对于已经过期的活动的添加，系统会自动判断过期并将活动状态改为“已过期”，同时对于过期的活动，无法被普通用户申请。（*）**
   - **增加系统的超级管理员，形成了超级管理员—系统管理员—普通用户的权限架构。（*）**
   - **为网页架构增加了逐帧动画效果以及页面美化。（*）**

**项目文件规整：**

1. Mysql中包含建立数据库的SQL语言以及触发器等代码 
2. PowerDesigner_file中包括cdm\ldm\pdm等PowerDesigner文件 
3. 系统设计图为上面文件的导出图 
4. 实验报告 
5. code.zip中为Django项目展示代码
