package com.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.util.DBUtil;

@WebServlet("/AdminManage")
public class AdminManageServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查管理员权限
        HttpSession session = request.getSession();
        if (!"true".equals(session.getAttribute("admin"))) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                addCandidate(request);
            } else if ("update".equals(action)) {
                updateCandidate(request);
            } else if ("delete".equals(action)) {
                deleteCandidate(request);
            } else if ("resetAll".equals(action)) {
                resetAllVotes();
            } else if ("updateTitle".equals(action)) {
                updateVoteTitle(request, request.getSession().getServletContext());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-manage.jsp");
    }

    private void addCandidate(HttpServletRequest request) throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String votesStr = request.getParameter("votes");
        int votes = votesStr != null ? Integer.parseInt(votesStr) : 0;

        // 1. 先添加候选人
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO candidates (name, description) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.executeUpdate();

            // 获取生成的ID
            var rs = pstmt.getGeneratedKeys();
            int candidateId = 0;
            if (rs.next()) {
                candidateId = rs.getInt(1);
            }

            // 2. 如果有初始票数，添加投票记录
            if (votes > 0 && candidateId > 0) {
                addVotesForCandidate(candidateId, votes);
            }

        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

    private void updateCandidate(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int votes = Integer.parseInt(request.getParameter("votes"));

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();

            // 1. 更新候选人信息
            String sql = "UPDATE candidates SET name = ?, description = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.setInt(3, id);
            pstmt.executeUpdate();
            pstmt.close();

            // 2. 先删除所有投票记录
            sql = "DELETE FROM votes WHERE candidate_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            pstmt.close();

            // 3. 重新添加指定票数
            if (votes > 0) {
                addVotesForCandidate(id, votes);
            }

        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

    private void deleteCandidate(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();

            // 1. 先删除投票记录
            String sql = "DELETE FROM votes WHERE candidate_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            pstmt.close();

            // 2. 再删除候选人
            sql = "DELETE FROM candidates WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

    // 为候选人添加指定数量的投票记录
    private void addVotesForCandidate(int candidateId, int voteCount) throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement pstmt = null;

        try {
            String sql = "INSERT INTO votes (candidate_id, session_id, ip_address) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < voteCount; i++) {
                String sessionId = "admin_" + System.currentTimeMillis() + "_" + i;
                String ip = "127.0.0." + (i % 255 + 1);

                pstmt.setInt(1, candidateId);
                pstmt.setString(2, sessionId);
                pstmt.setString(3, ip);
                pstmt.addBatch();

                // 每100条执行一次批处理
                if (i % 100 == 0) {
                    pstmt.executeBatch();
                }
            }
            pstmt.executeBatch();

        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

    // 重置所有投票
    private void resetAllVotes() throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement pstmt = null;

        try {
            String sql = "TRUNCATE TABLE votes";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

    // 更新投票主题
    private void updateVoteTitle(HttpServletRequest request, ServletContext application) {
        String voteTitle = request.getParameter("voteTitle");
        if (voteTitle != null && !voteTitle.trim().isEmpty()) {
            // 将投票主题保存到application范围（整个应用可见）
            application.setAttribute("voteTitle", voteTitle.trim());
            System.out.println("投票主题已更新为: " + voteTitle);
        }
    }
}