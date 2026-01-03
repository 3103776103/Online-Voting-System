package com.util;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DBUtil {
    // 数据库配置 - 请修改为您的实际配置
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/zktJava?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false";
    private static final String USER = "root";  // 修改为您的数据库用户名
    private static final String PASSWORD = ""; // 数据库密码是空的

    // 静态代码块：加载数据库驱动
    static {
        try {
            Class.forName(DRIVER);
            System.out.println("数据库驱动加载成功 - 张可天");
        } catch (ClassNotFoundException e) {
            System.err.println("错误：找不到MySQL驱动，请将mysql-connector-java-8.0.33.jar放在正确位置");
            e.printStackTrace();
        }
    }

    // 获取数据库连接
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功 - " + new java.util.Date());
            return conn;
        } catch (SQLException e) {
            System.err.println("数据库连接失败，请检查配置：");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("错误信息: " + e.getMessage());
            throw e;
        }
    }

    // 关闭数据库资源
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 执行查询操作，返回结果列表
    public static List<Map<String, Object>> executeQuery(String sql, Object... params) {
        List<Map<String, Object>> resultList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            rs = pstmt.executeQuery();
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i);
                    Object value = rs.getObject(i);
                    row.put(columnName, value);
                }
                resultList.add(row);
            }

            System.out.println("SQL查询执行成功: " + sql);

        } catch (SQLException e) {
            System.err.println("SQL查询执行失败: " + sql);
            System.err.println("错误信息: " + e.getMessage());
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return resultList;
    }

    // 执行更新操作（增删改）
    public static int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开启事务

            pstmt = conn.prepareStatement(sql);

            // 设置参数
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            int result = pstmt.executeUpdate();
            conn.commit(); // 提交事务

            System.out.println("SQL更新执行成功: " + sql + "，影响行数: " + result);
            return result;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // 回滚事务
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("SQL更新执行失败: " + sql);
            System.err.println("错误信息: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            close(conn, pstmt, null);
        }
    }

    // ========== 业务方法 ==========

    // 获取所有候选人及票数
    public static List<Map<String, Object>> getAllCandidatesWithVotes() {
        String sql = "SELECT c.id, c.name, c.description, COUNT(v.id) as vote_count " +
                     "FROM candidates c " +
                     "LEFT JOIN votes v ON c.id = v.candidate_id " +
                     "GROUP BY c.id, c.name, c.description " +
                     "ORDER BY vote_count DESC";
        return executeQuery(sql);
    }

    // 获取总投票数
    public static int getTotalVotes() {
        String sql = "SELECT COUNT(*) as total FROM votes";
        List<Map<String, Object>> result = executeQuery(sql);
        if (!result.isEmpty()) {
            Object total = result.get(0).get("total");
            if (total instanceof Long) {
                return ((Long) total).intValue();
            } else if (total instanceof Integer) {
                return (Integer) total;
            }
        }
        return 0;
    }

    // 检查会话是否已投票
    public static boolean hasVoted(String sessionId) {
        String sql = "SELECT COUNT(*) as count FROM votes WHERE session_id = ?";
        List<Map<String, Object>> result = executeQuery(sql, sessionId);
        if (!result.isEmpty()) {
            Object count = result.get(0).get("count");
            if (count instanceof Long) {
                return ((Long) count).intValue() > 0;
            } else if (count instanceof Integer) {
                return (Integer) count > 0;
            }
        }
        return false;
    }

    // 记录投票
    public static boolean recordVote(int candidateId, String sessionId, String ipAddress) {
        String sql = "INSERT INTO votes (candidate_id, session_id, ip_address) VALUES (?, ?, ?)";
        return executeUpdate(sql, candidateId, sessionId, ipAddress) > 0;
    }

    // 获取候选人票数
    public static int getVoteCount(int candidateId) {
        String sql = "SELECT COUNT(*) as count FROM votes WHERE candidate_id = ?";
        List<Map<String, Object>> result = executeQuery(sql, candidateId);
        if (!result.isEmpty()) {
            Object count = result.get(0).get("count");
            if (count instanceof Long) {
                return ((Long) count).intValue();
            } else if (count instanceof Integer) {
                return (Integer) count;
            }
        }
        return 0;
    }

    // 获取候选人信息
    public static Map<String, Object> getCandidateById(int candidateId) {
        String sql = "SELECT * FROM candidates WHERE id = ?";
        List<Map<String, Object>> result = executeQuery(sql, candidateId);
        if (!result.isEmpty()) {
            return result.get(0);
        }
        return null;
    }

    // 测试数据库连接
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}