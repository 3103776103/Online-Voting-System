<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.VoteBean" %>
<%@ page import="com.bean.VoteBean.Candidate" %>
<%@ page import="java.util.List" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (!"true".equals(admin)) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String voteTitle = (String) application.getAttribute("voteTitle");
    if (voteTitle == null || voteTitle.isEmpty()) {
        voteTitle = "学生会主席在线投票系统";
    }

    VoteBean voteBean = new VoteBean();
    List<Candidate> candidates = voteBean.getCandidates();
    int totalVotes = voteBean.getTotalVotes();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>投票管理 - 管理员</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="header d-flex justify-content-between align-items-center">
            <div>
                <h4>🛠️ 投票系统管理</h4>
                <p class="mb-0">欢迎，管理员：<strong><%= session.getAttribute("adminUsername") != null ?
                    session.getAttribute("adminUsername") : "管理员" %></strong></p>
            </div>
            <div>
                <a href="index.jsp" class="btn btn-light btn-sm me-2">
                    🗳️ 查看投票页面
                </a>
                <a href="AdminLogin?action=logout" class="btn btn-outline-light btn-sm">
                    🔓 退出登录
                </a>
            </div>
        </div>

        <div class="system-settings">
            <h5>⚙️ 系统设置</h5>
            <form action="AdminManage" method="post" class="row g-3 align-items-center">
                <input type="hidden" name="action" value="updateTitle">
                <div class="col-md-5">
                    <label class="form-label">投票主题：</label>
                    <input type="text" name="voteTitle" class="form-control"
                           value="<%= voteTitle %>" placeholder="输入投票主题" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">当前主题：</label>
                    <p class="form-control-plaintext"><strong><%= voteTitle %></strong></p>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-warning w-100">更新主题</button>
                </div>
            </form>
        </div>

        <div class="card mb-4">
            <div class="card-body">
                <h5>➕ 添加新候选人</h5>
                <form action="AdminManage" method="post" class="row g-3">
                    <input type="hidden" name="action" value="add">
                    <div class="col-md-4">
                        <input type="text" name="name" class="form-control" placeholder="姓名" required>
                    </div>
                    <div class="col-md-5">
                        <input type="text" name="description" class="form-control" placeholder="描述" required>
                    </div>
                    <div class="col-md-3">
                        <input type="number" name="votes" class="form-control" placeholder="初始票数" value="0">
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">添加</button>
                    </div>
                </form>
            </div>
        </div>

        <h5>👥 候选人管理（共 <%= candidates.size() %> 人）</h5>
        <% for (Candidate candidate : candidates) { %>
        <div class="candidate-row">
            <form action="AdminManage" method="post" class="row g-3 align-items-center">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= candidate.getId() %>">

                <div class="col-md-3">
                    <input type="text" name="name" class="form-control"
                           value="<%= candidate.getName() %>" required>
                </div>
                <div class="col-md-4">
                    <input type="text" name="description" class="form-control"
                           value="<%= candidate.getDescription() %>" required>
                </div>
                <div class="col-md-2">
                    <input type="number" name="votes" class="form-control"
                           value="<%= candidate.getVoteCount() %>" min="0" required>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-success btn-sm">更新</button>
                    <button type="button" class="btn btn-danger btn-sm"
                            onclick="deleteCandidate(<%= candidate.getId() %>)">删除</button>
                </div>
            </form>
        </div>
        <% } %>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">📊 投票统计</h5>
                        <p class="card-text">
                            总投票数: <strong><%= totalVotes %></strong><br>
                            候选人数量: <strong><%= candidates.size() %></strong><br>
                            当前主题: <strong><%= voteTitle %></strong><br>
                            更新时间: <strong><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></strong>
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">⚠️ 危险操作</h5>
                        <p class="card-text">
                            <small>谨慎操作，这些操作会影响所有数据</small>
                        </p>
                        <form action="AdminManage" method="post"
                              onsubmit="return confirm('⚠️ 确定要重置所有投票吗？此操作不可撤销！')"
                              class="mb-2">
                            <input type="hidden" name="action" value="resetAll">
                            <button type="submit" class="btn btn-danger w-100">重置所有投票</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <form id="deleteForm" action="AdminManage" method="post" style="display:none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="id" id="deleteId">
    </form>

    <script>
        function deleteCandidate(id) {
            if (confirm('确定要删除这个候选人吗？')) {
                document.getElementById('deleteId').value = id;
                document.getElementById('deleteForm').submit();
            }
        }
    </script>
</body>
</html>