# Online Voting System

一个基于Java Web技术的在线投票系统课程设计。系统采用MVC模式，实现了用户投票、实时结果展示、管理员管理等功能。
## 功能特性

- **用户端**
  - 浏览候选人信息（响应式卡片布局）
  <img width="1912" height="994" alt="主页面" src="https://github.com/user-attachments/assets/72fa49b3-fb47-4bdb-b5b1-b0ebf1fc69d2" />

  - 进行投票（基于Session的防重复投票机制）
  <img width="1912" height="994" alt="投票状态展示" src="https://github.com/user-attachments/assets/b4aa7f29-8be0-4201-b6ae-f2e2e671f94d" />

  - 查看实时投票结果（进度条可视化，支持智能并列排名处理）
  <img width="1912" height="994" alt="唯一领先者结果" src="https://github.com/user-attachments/assets/66949c97-6c45-4507-9b09-2a8768a17bf9" />

- **管理员端**
  - 安全的登录验证
  <img width="1912" height="994" alt="管理员" src="https://github.com/user-attachments/assets/6573eb0c-e6c4-4fe4-a897-d6c76c0b1e0e" />

  - 对候选人进行增删改查(CRUD)管理
  <img width="1912" height="994" alt="候选人管理" src="https://github.com/user-attachments/assets/8b95b4ab-630a-41a9-bc54-f407aa56015e" />

  - 重置投票数据、配置系统主题
  <img width="637" height="163" alt="投票统计" src="https://github.com/user-attachments/assets/c7708c09-d219-4c52-beaa-3b0c5cd9e610" />
  <img width="637" height="153" alt="重置" src="https://github.com/user-attachments/assets/c06f6981-6e5f-4721-9908-f876784b7ec5" />
  <img width="1297" height="140" alt="更换主题" src="https://github.com/user-attachments/assets/a2f8f954-5f90-484b-8519-081428b68b70" />

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
online-voting-system/
├── src/main/java/ # Java 源代码
│ ├── controller/ # Servlet控制器
│ ├── model/ # 数据模型/JavaBean
│ └── util/ # 工具类（如DBUtil）
├── src/main/webapp/ # Web资源
│ ├── WEB-INF/ # 配置和库
│ ├── css/ # 样式表
│ ├── js/ # JavaScript文件
│ ├── index.jsp # 首页
│ └── result.jsp # 结果页
├── sql/ # 数据库脚本
├── pom.xml # Maven依赖配置
