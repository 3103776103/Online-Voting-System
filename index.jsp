<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.VoteBean" %>
<%@ page import="com.bean.VoteBean.Candidate" %>
<%@ page import="java.util.List" %>
<%
    VoteBean voteBean = new VoteBean();
    List<Candidate> candidates = voteBean.getCandidates();
    int totalVotes = voteBean.getTotalVotes();

    String message = (String) request.getAttribute("message");
    String hasVoted = (String) session.getAttribute("hasVoted");

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
    <title><%= voteTitle %>（数据库版）- 张可天</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
</head>
<body>
    <div class="school-logo">
        <a href="https://www.bucea.edu.cn/" target="_blank" title="访问北京建筑大学官网">
            <img src="images/school-logo.png" alt="北京建筑大学校徽">
        </a>
        <a href="admin-login.jsp" class="admin-btn" title="管理员登录">
            🔧 管理员
        </a>
    </div>

    <div class="marquee-container">
        <div class="marquee-content">
            🏫 北京建筑大学 ｜ 📚 计算机科学与技术 ｜ 👨‍🎓 计232 张可天 ｜ 💻 JavaWeb课程设计 ｜ 🗳️ <%= voteTitle %> ｜ 🎯 数据库版本 ｜ ✅ 数据持久化存储 ｜ 🔄 实时统计更新 ｜ 🏆 公平公正公开
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="vote-card">
                    <div class="user-info">
                        <p class="mb-1">欢迎使用投票系统（数据库版本）<span class="database-badge">MySQL</span></p>
                        <p class="mb-0">会话ID: <%= session.getId().substring(0, 15) %>... | 数据库: zktJava</p>
                    </div>

                    <h1 class="text-center mb-4 vote-title">
                        🗳️ <%= voteTitle %>
                    </h1>
                    <p class="text-center text-muted mb-4">数据持久化存储，永不丢失</p>

                    <% if (message != null) { %>
                        <div class="alert alert-warning" role="alert">
                            <%= message %>
                        </div>
                    <% } %>

                    <% if ("true".equals(hasVoted)) { %>
                        <div class="alert alert-info" role="alert">
                            ✅ 您已经投过票了，可以查看<a href="result.jsp" class="alert-link">实时投票结果</a>
                        </div>
                    <% } %>

                    <form id="voteForm" action="vote" method="post">
                        <div class="candidates-list">
                            <%
                                for (Candidate candidate : candidates) {
                                    double percentage = voteBean.getPercentage(candidates.indexOf(candidate));
                            %>
                            <div class="candidate-card" onclick="selectCandidate(<%= candidate.getId() %>)">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio"
                                           name="candidate"
                                           id="candidate<%= candidate.getId() %>"
                                           value="<%= candidate.getId() %>"
                                           <%= "true".equals(hasVoted) ? "disabled" : "" %>
                                           required>
                                    <label class="form-check-label" for="candidate<%= candidate.getId() %>">
                                        <h5 class="mb-2">
                                            <%= candidate.getName() %>
                                            <span class="badge bg-primary">
                                                <%= candidate.getVoteCount() %> 票 (<%= String.format("%.1f", percentage) %>%)
                                            </span>
                                        </h5>
                                        <p class="candidate-description mb-2">
                                            <small><%= candidate.getDescription() %></small>
                                        </p>
                                        <div class="progress">
                                            <div class="progress-bar bg-success"
                                                 role="progressbar"
                                                 style="width: <%= percentage %>%">
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <div class="text-center mt-4">
                            <% if (!"true".equals(hasVoted)) { %>
                                <button type="submit" class="btn vote-btn text-white">
                                    🗳️ 提交投票（保存到数据库）
                                </button>
                            <% } %>
                            <a href="result.jsp" class="btn btn-outline-primary ms-3">
                                📊 查看实时结果
                            </a>
                            <a href="testdb.jsp" class="btn btn-outline-secondary ms-3">
                                🗄️ 测试数据库连接
                            </a>
                        </div>
                    </form>

                    <div class="mt-4 pt-3 border-top">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    <small>
                                        • 总投票数: <strong><%= totalVotes %></strong> 票<br>
                                        • 候选人数量: <strong><%= candidates.size() %></strong> 人<br>
                                        • 客户端IP: <%= request.getRemoteAddr() %><br>
                                        • 服务器: <%= application.getServerInfo() %>
                                    </small>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p class="text-muted">
                                    <small>
                                        • 数据库: MySQL 8.0<br>
                                        • 投票主题: <strong><%= voteTitle %></strong><br>
                                        • 系统版本: 数据库版 v1.0<br>
                                        • 开发者: 张可天 - 北京建筑大学
                                    </small>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectCandidate(id) {
            if (document.getElementById('candidate' + id).disabled) {
                return;
            }

            document.querySelectorAll('.candidate-card').forEach(card => {
                card.classList.remove('selected');
            });

            event.currentTarget.classList.add('selected');
            document.getElementById('candidate' + id).checked = true;
        }

        document.getElementById('voteForm').addEventListener('submit', function(e) {
            const selected = document.querySelector('input[name="candidate"]:checked');
            if (!selected) {
                e.preventDefault();
                alert('请选择一个候选人！');
                return false;
            }

            const candidateName = document.querySelector('label[for="candidate' + selected.value + '"] h5').textContent.split(' ')[0];
            return confirm('确认投票给 ' + candidateName + ' 吗？投票将永久保存到数据库。');
        });

        const marqueeTexts = [
            "🏫 北京建筑大学 ｜ 📚 计算机科学与技术 ｜ 👨‍🎓 计232 张可天 ｜ 💻 JavaWeb课程设计",
            "🗳️ <%= voteTitle %> ｜ 🎯 数据库版本 ｜ ✅ 数据持久化存储 ｜ 🔄 实时统计更新",
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