package com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter("/*")
public class InitFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 过滤器初始化时设置默认主题
        ServletContext application = filterConfig.getServletContext();
        if (application.getAttribute("voteTitle") == null) {
            application.setAttribute("voteTitle", "学生会主席在线投票系统");
            System.out.println("初始化默认投票主题: 学生会主席在线投票系统");
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
}