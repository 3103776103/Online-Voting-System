# Online Voting System

一个基于Java Web技术的在线投票系统课程设计。系统采用MVC模式，实现了用户投票、实时结果展示、管理员管理等功能。

## 功能特性

- **用户端**
  - 浏览候选人信息（响应式卡片布局）
  - 进行投票（基于Session的防重复投票机制）
  - 查看实时投票结果（进度条可视化，支持智能并列排名处理）

- **管理员端**
  - 安全的登录验证
  - 对候选人进行增删改查(CRUD)管理
  - 重置投票数据、配置系统主题

## 技术栈

- **后端:** Java, Servlet, JSP
- **前端:** HTML5, CSS3, JavaScript, Bootstrap 5
- **数据库:** MySQL 8.0
- **服务器:** Apache Tomcat
- **开发工具:** IntelliJ IDEA / Eclipse
- **项目管理:** Maven

## 系统架构

本项目遵循经典的**MVC（Model-View-Controller）三层架构**：
- **模型(Model):** JavaBean封装业务逻辑和数据（如 `VoteBean`, `Candidate`）
- **视图(View):** JSP页面结合Bootstrap渲染用户界面
- **控制器(Controller):** Servlet处理请求和路由（如 `VoteServlet`, `AdminManageServlet`）

## 如何运行

1.  **克隆项目**
    ```bash
    git clone https://github.com/你的用户名/online-voting-system.git
    ```

2.  **导入项目**
    - 使用 IntelliJ IDEA 或 Eclipse，选择导入 **Maven 项目**。

3.  **数据库配置**
    - 在MySQL中创建一个数据库（如 `voting_system`）。
    - 执行项目 `sql/` 目录下的数据库脚本（如果提供）来创建表和初始数据。
    - 在 `src/main/resources`（或`WEB-INF`下的）`db.properties` 或相关配置文件中，修改数据库连接信息（URL、用户名、密码）。

4.  **部署运行**
    - 在IDE中配置Tomcat服务器。
    - 将项目添加到服务器并启动。
    - 访问 `http://localhost:8080/你的项目上下文路径`。

## 项目结构说明
