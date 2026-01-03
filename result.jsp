<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.VoteBean" %>
<%@ page import="com.bean.VoteBean.Candidate" %>
<%@ page import="java.util.List" %>
<%
    VoteBean voteBean = new VoteBean();
    List<Candidate> candidates = voteBean.getCandidates();
    int total = voteBean.getTotalVotes();

    String voteTitle = (String) application.getAttribute("voteTitle");
    if (voteTitle == null || voteTitle.isEmpty()) {
        voteTitle = "学生会主席在线投票系统";
    }

    int maxVotes = 0;
    java.util.List<Candidate> topCandidates = new java.util.ArrayList<>();

    for (Candidate candidate : candidates) {
        if (candidate.getVoteCount() > maxVotes) {
            maxVotes = candidate.getVoteCount();
            topCandidates.clear();
            topCandidates.add(candidate);
        } else if (candidate.getVoteCount() == maxVotes) {
            topCandidates.add(candidate);
        }
    }

    int tieCount = topCandidates.size();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= voteTitle %> 结果 - 张可天</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/result.css" rel="stylesheet">
</head>
<body>
    <div class="school-logo">
        <a href="https://www.bucea.edu.cn/" target="_blank" title="访问北京建筑大学官网">
            <img src="images/school-logo.png" alt="北京建筑大学校徽">
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
                <div class="result-card">
                    <a href="index.jsp" class="btn btn-outline-primary mb-4">← 返回投票</a>

                    <h1 class="text-center mb-4 vote-title">
                        📊 <%= voteTitle %> 实时结果
                    </h1>

                    <div class="database-info">
                        <h5><span class="badge bg-success">MySQL数据库</span> zktJava</h5>
                        <p class="mb-1">数据来源：candidates表 + votes表 JOIN查询</p>
                        <p class="mb-0">数据统计时间：<%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></p>
                    </div>

                    <div class="winner-card text-center">
                        <% if (tieCount == 1) { %>
                            <h2>🏆 当前领先者</h2>
                            <h3 class="display-4"><%= topCandidates.get(0).getName() %></h3>
                            <p class="lead"><%= topCandidates.get(0).getVoteCount() %> 票
                            (<%= String.format("%.1f", voteBean.getPercentageById(topCandidates.get(0).getId())) %>%)</p>
                            <p class="mb-0"><small><%= topCandidates.get(0).getDescription() %></small></p>
                        <% } else if (tieCount <= 3) { %>
                            <h2>🏆 当前领先者（并列）</h2>
                            <div class="tie-row">
                                <% for (Candidate candidate : topCandidates) { %>
                                <div class="tie-candidate">
                                    <h4><%= candidate.getName() %></h4>
                                    <p class="mb-1"><strong><%= candidate.getVoteCount() %> 票</strong></p>
                                    <p class="mb-0"><small><%= candidate.getDescription() %></small></p>
                                </div>
                                <% } %>
                            </div>
                            <p class="mt-3 mb-0">所有领先者得票数相同：<strong><%= maxVotes %></strong> 票</p>
                        <% } else { %>
                            <h2>🏆 当前领先情况</h2>
                            <h3 class="display-5">当前并排人数过多</h3>
                            <p class="lead">已有 <span class="badge bg-danger" style="font-size: 1.5rem;"><%= tieCount %></span> 人并列</p>
                            <p class="mb-0"><small>请查看下方详细统计或联系管理员处理</small></p>
                        <% } %>
                    </div>

                    <div class="results-list mt-4">
                        <h4 class="mb-4">候选人详细统计：</h4>

                        <%
                            for (int i = 0; i < candidates.size(); i++) {
                                Candidate candidate = candidates.get(i);
                                double percentage = voteBean.getPercentage(i);
                                boolean isWinner = topCandidates.contains(candidate);
                        %>
                        <div class="candidate-result mb-3">
                            <div class="d-flex justify-content-between mb-2">
                                <h5>
                                    <%= candidate.getName() %>
                                    <% if (isWinner) { %>
                                        <span class="badge bg-danger">领先</span>
                                    <% } %>
                                    <small class="text-muted ms-2"><%= candidate.getDescription() %></small>
                                </h5>
                                <span class="fw-bold"><%= String.format("%.1f", percentage) %>%</span>
                            </div>
                            <div class="chart-bar">
                                <div class="chart-fill" style="width: <%= percentage %>%"></div>
                                <span class="vote-count"><%= candidate.getVoteCount() %> 票</span>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <div class="row mt-4 pt-4 border-top">
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">📈 投票统计</h5>
                                    <p class="card-text">
                                        <strong>数据库记录：</strong><br>
                                        总投票数: <strong><%= total %></strong><br>
                                        候选人数量: <strong><%= candidates.size() %></strong><br>
                                        平均票数: <strong><%= total > 0 ? String.format("%.1f", (double)total/candidates.size()) : 0 %></strong><br>
                                        最高票数: <strong><%= maxVotes %></strong> 票<br>
                                        领先者数量: <strong><%= tieCount %></strong> 人
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">ℹ️ 系统信息</h5>
                                    <p class="card-text">
                                        <strong>会话与服务器：</strong><br>
                                        Session ID: <%= session.getId().substring(0, 10) %>...<br>
                                        服务器: <%= application.getServerInfo() %><br>
                                        客户端IP: <%= request.getRemoteAddr() %><br>
                                        投票主题: <strong><%= voteTitle %></strong>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <h5>您的投票状态：</h5>
                        <%
                            String hasVotedFlag = (String) session.getAttribute("hasVoted");
                            Object votedForObj = session.getAttribute("votedFor");

                            if ("true".equals(hasVotedFlag)) {
                                if (votedForObj != null) {
                                    try {
                                        int votedIndex = Integer.parseInt(votedForObj.toString());
                                        Candidate votedCandidate = null;
                                        for (Candidate c : candidates) {
                                            if (c.getId() == votedIndex) {
                                                votedCandidate = c;
                                                break;
                                            }
                                        }

                                        if (votedCandidate != null) {
                        %>
                        <div class="alert alert-success">
                            ✅ <strong>您已成功投票！</strong><br>
                            投票对象: <%= votedCandidate.getName() %><br>
                            当前票数: <%= votedCandidate.getVoteCount() %> 票<br>
                            <small>投票时间: <%= session.getAttribute("voteTime") != null ?
                                    session.getAttribute("voteTime") : new java.util.Date() %></small>
                        </div>
                        <%
                                        } else {
                        %>
                        <div class="alert alert-info">
                            ℹ️ 您已经投过票了，投票记录已保存到数据库
                        </div>
                        <%
                                        }
                                    } catch (Exception e) {
                        %>
                        <div class="alert alert-info">
                            ℹ️ 您已经投过票了（数据库已记录）
                        </div>
                        <%
                                    }
                                } else {
                        %>
                        <div class="alert alert-info">
                            ℹ️ 您已经投过票了
                        </div>
                        <%
                                }
                            } else {
                        %>
                        <div class="alert alert-warning">
                            ⚠️ 您尚未投票
                        </div>
                        <%
                            }
                        %>
                    </div>

                    <div class="mt-4 pt-3 border-top">
                        <h6><small class="text-muted">执行的SQL查询：</small></h6>
                        <pre class="bg-light p-2 rounded" style="font-size: 0.8em;">
SELECT c.id, c.name, c.description, COUNT(v.id) as vote_count
FROM candidates c
LEFT JOIN votes v ON c.id = v.candidate_id
GROUP BY c.id
ORDER BY vote_count DESC</pre>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
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