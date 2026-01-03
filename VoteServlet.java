package com.servlet;

import com.bean.VoteBean;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/vote")
public class VoteServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // 获取参数
        String candidateIdStr = request.getParameter("candidate");
        HttpSession session = request.getSession();
        String sessionId = session.getId();
        String ipAddress = request.getRemoteAddr();
        
        if (candidateIdStr == null || candidateIdStr.trim().isEmpty()) {
            request.setAttribute("message", "请选择一个候选人！");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        int candidateId = Integer.parseInt(candidateIdStr);
        
        // 检查是否已投票
        VoteBean voteBean = new VoteBean();
        if (voteBean.hasVoted(sessionId)) {
            request.setAttribute("message", "您已经投过票了，不能重复投票！");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        // 执行投票
        boolean success = voteBean.voteFor(candidateId, sessionId, ipAddress);
        
        if (success) {
            // 投票成功，设置session标记
            session.setAttribute("hasVoted", "true");
            session.setAttribute("votedFor", String.valueOf(candidateId));
            session.setAttribute("voteTime", new java.util.Date().toString());
            
            // 记录日志
            System.out.println("投票成功 - 候选人ID: " + candidateId + 
                             ", Session: " + sessionId.substring(0, 10) + 
                             ", IP: " + ipAddress);
            
            response.sendRedirect("result.jsp");
        } else {
            request.setAttribute("message", "投票失败，请稍后重试！");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}