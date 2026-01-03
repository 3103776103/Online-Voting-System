<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String voteTitle = (String) application.getAttribute("voteTitle");
    if (voteTitle == null || voteTitle.isEmpty()) {
        voteTitle = "学生会主席在线投票系统";
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - <%= voteTitle %></title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body>
    <div class="login-box">
        <h4 class="text-center mb-4">🔐 管理员登录</h4>
        <p class="text-center text-muted mb-3"><small><%= voteTitle %></small></p>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">用户名或密码错误！</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/AdminLogin" method="post">
            <input type="text" name="username" class="form-control" placeholder="用户名" required>
            <input type="password" name="password" class="form-control" placeholder="密码" required>
            <button type="submit" class="btn btn-primary w-100">登录</button>
        </form>

        <div class="text-center mt-3">
            <a href="<%= request.getContextPath() %>/index.jsp" class="text-muted">返回投票页面</a>
        </div>
    </div>
</body>
</html>