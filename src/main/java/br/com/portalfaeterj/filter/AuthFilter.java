package br.com.portalfaeterj.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Protege painel e POSTs.
 * Valida se existe um usuário logado na sessão.
 */
@WebFilter(urlPatterns = {"/painel.jsp", "/noticia", "/evento"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Integer userId = null;

        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        // Se não estiver logado, manda para o login
        if (userId == null) {
            String context = req.getContextPath();
            String uri = req.getRequestURI();
            String target = "login.jsp";

            // Só pra manter o redirect bonitinho, igual aos servlets
            if (uri != null) {
                if (uri.endsWith("/painel.jsp") || uri.endsWith("/noticia")) {
                    target += "?redirect=painel.jsp";
                } else if (uri.endsWith("/evento")) {
                    target += "?redirect=eventos.jsp";
                }
            }

            resp.sendRedirect(context + "/" + target);
            return;
        }

        // Usuário logado → segue o fluxo normal (o servlet cuida da permissão de role)
        chain.doFilter(request, response);
    }
}
