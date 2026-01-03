<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> candidates = DBUtil.getAllCandidatesWithVotes();
    int totalVotes = DBUtil.getTotalVotes();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>数据库连接测试 - 张可天</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/testdb.css" rel="stylesheet">
</head>
<body>
    <div class="school-logo">
        <a href="https://www.bucea.edu.cn/" target="_blank" title="访问北京建筑大学官网">
            <img src="images/school-logo.png" alt="北京建筑大学校徽">
        </a>
    </div>

    <div class="marquee-container">
        <div class="marquee-content">
            🏫 北京建筑大学 ｜ 📚 计算机科学与技术 ｜ 👨‍🎓 计232 张可天 ｜ 💻 JavaWeb课程设计 ｜ 🗳️ 学生在线投票系统 ｜ 🎯 数据库版本 ｜ ✅ 数据持久化存储 ｜ 🔄 实时统计更新 ｜ 🏆 公平公正公开
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="test-card">
                    <h1>数据库连接测试页面</h1>
                    <p>项目：学生在线投票系统 | 开发者：张可天</p>

                    <div class="alert alert-info">
                        <h4>数据库配置信息：</h4>
                        <p>数据库：zktJava<br>
                           表：candidates（候选人表）、votes（投票记录表）<br>
                           驱动：MySQL Connector/J 8.0.33<br>
                           测试时间：<%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></p>
                    </div>

                    <h3>测试结果：</h3>

                    <% if (candidates != null && !candidates.isEmpty()) { %>
                        <div class="alert alert-success">
                            <h4>✅ 数据库连接成功！</h4>
                            <p>成功连接到MySQL数据库，共查询到 <%= candidates.size() %> 位候选人</p>
                        </div>

                        <h4>候选人数据：</h4>
                        <table class="table table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>姓名</th>
                                    <th>描述</th>
                                    <th>票数</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> row : candidates) { %>
                                <tr>
                                    <td><%= row.get("id") %></td>
                                    <td><%= row.get("name") %></td>
                                    <td><%= row.get("description") %></td>
                                    <td><%= row.get("vote_count") %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <div class="alert alert-secondary">
                            <h5>统计信息：</h5>
                            <p>总投票数：<strong><%= totalVotes %></strong><br>
                               数据更新时间：<%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></p>
                        </div>

                    <% } else { %>
                        <div class="alert alert-danger">
                            <h4>❌ 数据库连接失败！</h4>
                            <p>可能的原因：</p>
                            <ul>
                                <li>MySQL服务未启动</li>
                                <li>数据库连接配置错误</li>
                                <li>MySQL驱动未正确放置</li>
                                <li>数据库表不存在</li>
                            </ul>
                        </div>
                    <% } %>

                    <div class="mt-4">
                        <a href="index.jsp" class="btn btn-primary">返回投票主页</a>
                        <a href="result.jsp" class="btn btn-secondary">查看投票结果</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const marqueeTexts = [
            "🏫 北京建筑大学 ｜ 📚 计算机科学与技术 ｜ 👨‍🎓 计232 张可天 ｜ 💻 JavaWeb课程设计",
            "🗳️ 学生在线投票系统 ｜ 🎯 数据库版本 ｜ ✅ 数据持久化存储 ｜ 🔄 实时统计更新",
            "🏆 公平公正公开 ｜ 📊 实时数据统计 ｜ 🔐 安全可靠 ｜ 💾 MySQL数据库存储",
            "👨‍🏫 课程设计作品 ｜ 🎓 毕业设计基础 ｜ 💼 企业级应用 ｜ 🌐 Web开发实践"
        ];

        function changeMarqueeText() {
            const marquee = document.querySelector('.marquee-content');
            const randomIndex = Math.floor(Math.random() * marqueeTexts.length);
            marquee.textContent = marqueeTexts[randomIndex];
        }

        setInterval(changeMarqueeText, 30000);
    </script>
</body>
</html>