package br.com.portalfaeterj.filter;

import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

/** Protege painel e POSTs. Para demo, valida por sessão "user". */
@WebFilter(urlPatterns = {"/painel.jsp", "/noticia", "/evento"})
public class AuthFilter implements Filter {
    @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        Object user = req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect("login.jsp"); return; }
        chain.doFilter(request, response);
    }
}